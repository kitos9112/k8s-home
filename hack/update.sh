#!/usr/bin/env bash
source ${BASH_SOURCE[0]%/*}/common.sh

need "jq"

SEALED_SECRETS_RELEASE_FILE=".sealed-release.json"
SEALED_SECRETS_RELEASE_URL="https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest"
SEALED_SECRETS_CONTROLLER_FILE="${REPO_ROOT}/cluster/system/sealed-secrets/controller.yaml"
function upgrade_sealed_secrets() {
  curl -s -o ${SEALED_SECRETS_RELEASE_FILE} ${SEALED_SECRETS_RELEASE_URL}
  [ -f "${SEALED_SECRETS_RELEASE_FILE}" ] || die "failed to pull release data"

  version=$(jq -r '.name' ${SEALED_SECRETS_RELEASE_FILE})
  url=$(jq -r '.assets[] | select(.name == "controller.yaml") | .browser_download_url' ${SEALED_SECRETS_RELEASE_FILE})
  rm -f ${SEALED_SECRETS_RELEASE_FILE}
  [ "${url}" = "null" ] && die "failed to locate release url"

  curl -sL -o ${SEALED_SECRETS_CONTROLLER_FILE} ${url}
  echo "retrieved sealed-secrets manifest ${version}"
}

function usage() {
  echo "== update.sh"
  echo "usage: update.sh <sealed>"
  echo "  flux:     local flux cli binary"
  echo "  sealed:   sealed-secrets"
  exit
}

[[ -z "$1" ]] && usage
case "$1" in
  flux)
    shift ; shift ;
    source ${BASH_SOURCE[0]%/*}/update-flux.sh
    ;;
  sealed)
    upgrade_sealed_secrets
    ;;
  *)
    usage
    ;;
esac
