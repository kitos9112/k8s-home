#!/usr/bin/env bash
REPO_ROOT=$(git rev-parse --show-toplevel)
SCRIPT_DIR="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
CLUSTER="${SCRIPT_DIR}/../cluster"

export CLUSTER
export REPO_ROOT

function die() {
  echo "!! $*"
  exit 1
}

function log() {
  m_time=$(date "+%F %T")
  echo $m_time" "$1
}

function need() {
  which "$1" &>/dev/null || die "Binary '$1' is missing but required"
}

function load_env() {
  if [ "$(uname)" == "Darwin" ]; then
    set -a
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/.secrets.env"
    set +a
  else
    # shellcheck disable=SC1091
    source "${REPO_ROOT}/.secrets.env"
  fi
}
