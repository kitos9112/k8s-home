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
name=$(yq eval '.metadata.name' ${releaseFile})
repo=$(yq eval '.spec.chart.spec.sourceRef.name' ${releaseFile})
chart=$(yq eval '.spec.chart.spec.chart' ${releaseFile})

# dump the values into template
yq eval '.spec.values' ${releaseFile} |
  helm template ${name} "${repo}/${chart}" --values -
