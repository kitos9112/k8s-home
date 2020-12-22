#!/usr/bin/env bash
source ${BASH_SOURCE[0]%/*}/common.sh

# need "envsubst"
need "gomplate"
need "kubectl"
need "kubeseal"
need "yq"
load_env

function extract_ns() {
  yq eval ".namespace" "${1}/kustomization.yaml" 
}

# secret_template ns name
function secret_template() {
  rawJson="{apiVersion: \"v1\", kind: \"Secret\" }"
  namespace=${1}
  name=${2}

  echo ${rawJson} | yq eval '.. style= ""' - \
    | yq eval ".metadata.namespace = \"${namespace}\"" - \
    | yq eval ".metadata.name = \"${name}\"" -
}

# expand_values file
function expand_template_file() {
  gomplate \
    -c .=${REPO_ROOT}/.secrets.env \
    -d files=${REPO_ROOT}/.secrets/ \
    -f "${1}"
}

# process_secrets .secrets.yaml
function process_secrets() {
  expand_template_file ${1} | yq eval '{"data": .}' -
}

# process_values .values.yaml
function process_values() {
  echo "values.yaml: $(expand_template_file ${1} | base64)" | yq eval '{"data": .}' -
}

# file data-file
function write_sealed_secret() {
  file=${1}
  resourceSuffix=${2}

  base=$(basename "${file}")
  parent=$(dirname "${file}")
  ns=$(extract_ns "${parent}")
  sealedName="${base%%.*}${resourceSuffix}"
  sealedFile="cluster/secrets/${ns}/${sealedName}.yaml"

  [ "${file}" -ot "${sealedFile}" ] && return

  echo "generating: ${sealedFile}"
  mkdir -p "cluster/secrets/${ns}"
  yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' \
              <(secret_template ${ns} ${sealedName}) ${3} \
              | seal > "${sealedFile}"
}

function seal() {
  kubeseal --format=yaml \
    | yq eval 'del(.spec.template)' - \
    | yq eval 'del(.metadata.creationTimestamp)' -
}

function refresh_secrets() {
  # *.values.yaml
  while IFS= read -r -d '' file
  do
    write_sealed_secret "${file}" "-values" <(process_values ${file})
  done <  <(find cluster -type f -name '*.values.yaml' -print0)

  # *.secrets.yaml
  while IFS= read -r -d '' file
  do
    write_sealed_secret "${file}" "" <(process_secrets ${file})
  done <  <(find cluster -type f -name '*.secrets.yaml' -print0)
}

function write_kustomization() {
  cat <<EOF | sed -r 's/^ {4}//' > cluster/secrets/kustomization.yaml
    apiVersion: kustomize.config.k8s.io/v1beta1
    kind: Kustomization
    resources:
    $(find cluster/secrets/**/*.yaml | sed 's|^cluster/secrets/|- ./|')
EOF
}

function wipe_secrets() {
  echo "== wiping all secrets"
  rm -rf cluster/secrets
}

function check_secret_exists() {
  file=${1}
  resourceSuffix=${2}

  base=$(basename "${file}")
  parent=$(dirname "${file}")
  ns=$(extract_ns "${parent}")
  sealedName="${base%%.*}${resourceSuffix}"
  sealedFile="cluster/secrets/${ns}/${sealedName}.yaml"

  [ "${file}" -ot "${sealedFile}" ] && return
  echo "secret missing or outdated for: ${file}"
  EXIT_CODE=1
}

function check_secrets() {
  export EXIT_CODE=0
  file=${1}
  ext=${file#*\.}

  if [ "${ext}" == "values.yaml" ]; then
    check_secret_exists "${file}" "-values"
  fi

  if [ "${ext}" == "secrets.yaml" ]; then
    check_secret_exists "${file}" ""
  fi

  exit ${EXIT_CODE}
}

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
