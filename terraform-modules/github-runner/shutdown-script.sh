#! /bin/bash

# Arguments from metadata
ACTIONS_USER=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/actions-user -H "Metadata-Flavor: Google")
VAULT_ADDR=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/vault-server -H "Metadata-Flavor: Google")
REPO=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo -H "Metadata-Flavor: Google")
GITHUB_PAT_PATH=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/github-pat-secret-path -H "Metadata-Flavor: Google")

# Runner config
VAULT_TOKEN=$(</home/$ACTIONS_USER/.vault-token)
GITHUB_PAT=$(VAULT_TOKEN="$VAULT_TOKEN" vault read -address="$VAULT_ADDR" "$GITHUB_PAT_PATH" -format=json | jq -r .data.token)

REMOVAL_TOKEN=$(curl -s -X POST https://api.github.com/repos/${REPO}/actions/runners/remove-token -H "accept: application/vnd.github.v3+json" -H "authorization: token ${GITHUB_PAT}" | jq -r .token)

pushd ./runner

./svc.sh stop
./svc.sh uninstall

sudo -Hiu "$ACTIONS_USER" bash -c "cd /runner; ./config.sh remove --token '$REMOVAL_TOKEN'"
