#!/usr/bin/env bash
source ${BASH_SOURCE[0]%/*}/common.sh

need "yq"

function _usage() {
  echo "== usage: template.sh path/to/helm-release.yaml"
  echo "note:"
  echo "  - this will not pull valuesFrom values"
  echo "  - requires all helm repositories be installed locally"
  echo "  - requires release be from a helm repository and not git"
  echo
  exit
}

[ $# -ne 1 ] && _usage
releaseFile=${1}
[ -f "${releaseFile}" ] || _usage

# extract release, repository and chart names
name=$(yq r ${releaseFile} "metadata.name")
repo=$(yq r ${releaseFile} "spec.chart.spec.sourceRef.name")
chart=$(yq r ${releaseFile} "spec.chart.spec.chart")

# dump the values into template
yq r ${releaseFile} "spec.values" \
  | helm template ${name} "${repo}/${chart}" --values -
