#!/usr/bin/env bash
#+++++++++++++++++++
## Description: Validates all YAML files of my cluster and ensures `kustomization.yaml` are compliant
## Author: Marcos Soutullo
## Date: 06/07/2021
## Requirements:
##  + Recent GNU variant versions of the following usual CLI commands:
##    - find
##    - echo
##    - grep
##    - cat
##    - mkdir
##################

set -o nounset
set -o errexit
set -o errtrace
set -o pipefail

[[ -n $DEBUG ]] && set -x

source "${SCRIPT_DIR}/common.sh"

# need "envsubst"
need "kustomize"
need "kubeval"
need "gomplate"
need "kubectl"
need "kubeseal"
need "yq"

while IFS= read -r -d $'\0' file; do
    # Replace the relative path (../) covention with an empty string and finish by creating a new array
    path=(${file//..\// })
    log "INFO - Validating ${path[1]}"
    yq e --exit-status 'tag == "!!map" or tag== "!!seq"' $file > /dev/null
done < <(find ${CLUSTER} -type f -regextype egrep -regex '.*\.y[a]?ml$' -print0)


k="kustomization.yaml"
while IFS= read -r -d $'\0' file; do
    path=(${file//..\// })
    log "INFO - Validating kustomization ${path[1]/%\/$k}"
    kustomize build "${file/%$k}" | kubeval --ignore-missing-schemas
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done < <(find ${CLUSTER} -type f -name $k -print0)

exit 0
function usage() {
  echo "== secrets management"
  echo "usage: secrets.sh <check|refresh|write|wipe>"
  exit
}

[[ -z "$1" ]] && usage


case "$1" in
  check)
    check_secrets "${@:2}"
    ;;
  refresh)
    refresh_secrets
    write_kustomization
    ;;
  write)
    wipe_secrets
    refresh_secrets
    write_kustomization
    ;;
  wipe)
    wipe_secrets
    ;;
  *)
    usage
    ;;
esac
