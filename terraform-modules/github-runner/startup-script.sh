#! /bin/bash

set -e

# Arguments from metadata
ROLE_ID_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/role-id-path -H "Metadata-Flavor: Google")
SECRET_ID_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/secret-id-path -H "Metadata-Flavor: Google")
REPO=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo -H "Metadata-Flavor: Google")
GITHUB_PAT_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/github-pat-secret-path -H "Metadata-Flavor: Google")
RUNNER_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")
RUNNER_LABELS=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/runner-labels -H "Metadata-Flavor: Google")

if [[ $ROLE_ID_PATH == gs* ]]; then
    gsutil cp $ROLE_ID_PATH $HOME/vault-agent/role-id
    ROLE_ID_PATH="$HOME/vault-agent/role-id"
fi

if [[ $SECRET_ID_PATH == gs* ]]; then
    gsutil cp $SECRET_ID_PATH $HOME/vault-agent/secret-id
    SECRET_ID_PATH="$HOME/vault-agent/secret-id"
fi

# Install software
apt-get update
apt-get -y install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    jq

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

apt-get update
apt-get remove \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc
apt-get -y install \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    vault

# Configure actions user
groupadd -f docker
id -u actions &>/dev/null || useradd -m actions --groups docker

# Configure Vault agent
mkdir -p $HOME/vault-agent
rm -f $HOME/vault-agent/vault-agent.hcl
cat <<EOF >> $HOME/vault-agent/vault-agent.hcl
pid_file = "$HOME/vault-agent/pidfile"

vault {
    address = "https://clotho.broadinstitute.org:8200"
}

auto_auth {
    method "approle" {
        config = {
            role_id_file_path = "$ROLE_ID_PATH"
            secret_id_file_path = "$SECRET_ID_PATH"
            remove_secret_id_file_after_reading = false
        }
    }
    sink "file" {
        config = {
            path = "/home/actions/.vault-token"
            mode = 0400
        }
    }
    sink "file" {
        config = {
            path = "$HOME/.vault-token"
            mode = 0400
        }
    }
}
EOF
chmod 600 $HOME/vault-agent/*
nohup vault agent -config=$HOME/vault-agent/vault-agent.hcl &>/dev/null &

# Configure auto-restart
echo "0 3 * * * /sbin/shutdown -r now" | crontab -

# Runner config
mkdir -p runner
GITHUB_PAT=$(vault read $GITHUB_PAT_PATH -format=json | jq -r '.token')

REGISTRATION_TOKEN=$(curl -s -X POST https://api.github.com/repos/${REPO}/actions/runners/registration-token \ 
    -H "accept: application/vnd.github.everest-preview+json" \
    -H "authorization: token ${GITHUB_PAT}" | jq -r '.token')

LATEST_VERSION_LABEL=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')
LATEST_VERSION=$(echo ${LATEST_VERSION_LABEL:1})
RUNNER_FILE="actions-runner-linux-x64-${LATEST_VERSION}.tar.gz"
curl -O -L "https://github.com/actions/runner/releases/download/${LATEST_VERSION_LABEL}/${RUNNER_FILE}"
tar xzf "./${RUNNER_FILE}" -C runner --overwrite

chown -R actions ./runner
pushd ./runner

if [[ ! -z "$RUNNER_LABELS" ]]; then
    ./config.sh --unattended --url "https://github.com/${REPO}" --token $REGISTRATION_TOKEN --name $RUNNER_NAME --labels $RUNNER_LABELS
else
    ./config.sh --unattended --url "https://github.com/${REPO}" --token $REGISTRATION_TOKEN --name $RUNNER_NAME
fi

./svc.sh install actions
./svc.sh start
