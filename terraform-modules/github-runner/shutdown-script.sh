#! /bin/bash

set -e

# Arguments from metadata
REPO=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/repo -H "Metadata-Flavor: Google")

# Runner config
GITHUB_PAT=$(vault read ...)

REMOVAL_TOKEN=$(curl -s -X POST https://api.github.com/repos/${REPO}/actions/runners/remove-token \ 
    -H "accept: application/vnd.github.everest-preview+json" \
    -H "authorization: token ${GITHUB_PAT}" | jq -r '.token')

pushd ./runner

./svc.sh stop
./svc.sh uninstall

./config.sh remove --token $REMOVAL_TOKEN