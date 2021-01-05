#! /bin/bash

set -e

# Arguments from metadata
ACTIONS_USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/actions-user -H "Metadata-Flavor: Google")
VAULT_ADDR=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/vault-server -H "Metadata-Flavor: Google")
ROLE_ID_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/role-id-path -H "Metadata-Flavor: Google")
SECRET_ID_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/secret-id-path -H "Metadata-Flavor: Google")
REPO=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo -H "Metadata-Flavor: Google")
GITHUB_PAT_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/github-pat-secret-path -H "Metadata-Flavor: Google")
RUNNER_LABELS=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/runner-labels -H "Metadata-Flavor: Google")
RUNNER_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/name" -H "Metadata-Flavor: Google")

mkdir -p "/vault-agent"

if [[ "$ROLE_ID_PATH" == gs* ]]; then
    gsutil cp "$ROLE_ID_PATH" "/vault-agent/role-id"
    ROLE_ID_PATH="/vault-agent/role-id"
fi

if [[ "$SECRET_ID_PATH" == gs* ]]; then
    gsutil cp "$SECRET_ID_PATH" "/vault-agent/secret-id"
    SECRET_ID_PATH="/vault-agent/secret-id"
fi

# Configure users
id -u "$ACTIONS_USER" >/dev/null 2>&1 || sudo useradd -m "$ACTIONS_USER"
sudo -Hiu "$ACTIONS_USER" bash -c 'gcloud auth configure-docker --quiet'

# Install software
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    jq

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository \
    "deb [arch=amd64] https://apt.releases.hashicorp.com \
    $(lsb_release -cs) \
    main"

sudo apt-get update
sudo apt-get -y install \
    vault \
    uidmap

sudo snap install --classic kubectl

# Install/configure docker to run as actions user
rm -rf "/home/$ACTIONS_USER/bin/dockerd" "/home/$ACTIONS_USER/.docker/run"
sudo -Hiu "$ACTIONS_USER" bash -c "curl -fsSL https://get.docker.com/rootless | sh"
rm -f "/docker.log"
sudo -Hiu "$ACTIONS_USER" XDG_RUNTIME_DIR="/home/$ACTIONS_USER/.docker/run" nohup /home/actions/bin/dockerd-rootless.sh --experimental >"/docker.log" 2>&1 &
echo "Docker logs available in /docker.log"

# Configure Vault agent
rm -f "/vault-agent/vault-agent.hcl"
cat <<EOF >>"/vault-agent/vault-agent.hcl"
pid_file = "/vault-agent/pidfile"

vault {
    address = "$VAULT_ADDR"
}

auto_auth {
    method "approle" {
        config = {
            role_id_file_path = "$ROLE_ID_PATH"
            secret_id_file_path = "$SECRET_ID_PATH"
        }
    }
    sink "file" {
        config = {
            path = "/home/$ACTIONS_USER/.vault-token"
            mode = 0660
        }
    }
}
EOF
chmod 600 /vault-agent/*
chown -R "$ACTIONS_USER" /vault-agent/
rm -f "/vault-agent.log"
sudo -Hiu "$ACTIONS_USER" nohup vault agent -config="/vault-agent/vault-agent.hcl" >"/vault-agent.log" 2>&1 &
echo "Vault agent logs available in /vault-agent.log, sleeping to let it come online..."
sleep 10s

# Configure auto-restart
echo "0 3 * * * /sbin/shutdown -r now" | crontab -

# Runner config
mkdir -p runner
VAULT_TOKEN=$(</home/$ACTIONS_USER/.vault-token)
GITHUB_PAT=$(VAULT_TOKEN="$VAULT_TOKEN" vault read -address="$VAULT_ADDR" "$GITHUB_PAT_PATH" -format=json | jq -r .data.token)

REGISTRATION_TOKEN=$(curl -s -X POST https://api.github.com/repos/${REPO}/actions/runners/registration-token -H "accept: application/vnd.github.v3+json" -H "authorization: token ${GITHUB_PAT}" | jq -r '.token')

LATEST_VERSION_LABEL=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r .tag_name)
LATEST_VERSION=$(echo ${LATEST_VERSION_LABEL:1})
RUNNER_FILE="actions-runner-linux-x64-${LATEST_VERSION}.tar.gz"
curl -O -L "https://github.com/actions/runner/releases/download/${LATEST_VERSION_LABEL}/${RUNNER_FILE}"
tar xzf "./${RUNNER_FILE}" -C runner --overwrite

# Set up environment variables for the runner
touch ./runner/.env
declare -a VARS=(
    "VAULT_ADDR=$VAULT_ADDR"
    "DOCKER_HOST=unix:///home/$ACTIONS_USER/.docker/run/docker.sock"
    "XDG_RUNTIME_DIR=/home/$ACTIONS_USER/.docker/run"
)
for VAR in "${VARS[@]}"; do
    if ! grep -Fxq "$VAR" ./runner/.env; then
        echo "$VAR" >>./runner/.env
    fi
done

chown -R "$ACTIONS_USER" ./runner
pushd ./runner

# Start runner
if [[ -z "$RUNNER_LABELS" ]]; then
    sudo -Hiu "$ACTIONS_USER" bash -c \
        "cd /runner; \
        ./config.sh --unattended --replace \
        --url 'https://github.com/${REPO}' \
        --token '$REGISTRATION_TOKEN' \
        --name '$RUNNER_NAME'"
else
    sudo -Hiu "$ACTIONS_USER" bash -c \
        "cd /runner; \
        ./config.sh --unattended --replace \
        --url 'https://github.com/${REPO}' \
        --token '$REGISTRATION_TOKEN' \
        --name '$RUNNER_NAME' \
        --labels '$RUNNER_LABELS'"
fi

./svc.sh install "$ACTIONS_USER"
./svc.sh start
