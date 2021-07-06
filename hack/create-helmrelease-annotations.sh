#!/usr/bin/env bash
shopt -s globstar

# shellcheck disable=SC2155
REPO_ROOT=$(git rev-parse --show-toplevel)
CLUSTER_ROOT="${REPO_ROOT}/cluster"
HELM_REPOSITORIES="${CLUSTER_ROOT}/cluster/base/flux-system/charts/helm"

# Ensure yq exist
command -v yq >/dev/null 2>&1 || {
    echo >&2 "yq is not installed. Aborting."
    exit 1
}

for helm_release in $(find ${CLUSTER_ROOT} -name "*helm-release.yaml"); do
    # ignore flux-system namespace
    # ignore wrong apiVersion
    # ignore non HelmReleases

    if [[ "${helm_release}" =~ .*"monitoring/kube-prometheus-stack/kube-state-metrics".* ]]; then
        continue
    fi

    if [[ "${helm_release}" =~ "flux-system"
        || $(yq eval '.apiVersion' "${helm_release}") != "helm.toolkit.fluxcd.io/v2beta1"
        || $(yq eval '.kind' "${helm_release}") != "HelmRelease" ]]; then
        continue
    fi

    for helm_repository in "${HELM_REPOSITORIES}"/*.yaml; do
        chart_name=$(yq eval '.metadata.name' "${helm_repository}")
        chart_url=$(yq eval '.spec.url' "${helm_repository}")

        # only helmreleases where helm_release is related to chart_url
        if [[ $(yq eval '.spec.chart.spec.sourceRef.name' "${helm_release}") == "${chart_name}" ]]; then
            # delete "renovate: registryUrl=" line
            sed -i "/renovate: registryUrl=/d" "${helm_release}"
            # insert "renovate: registryUrl=" line
            sed -i "/.*chart: .*/i \ \ \ \ \ \ # renovate: registryUrl=${chart_url}" "${helm_release}"
            echo "Annotated $(basename "${helm_release%.*}") with ${chart_name} for renovatebot..."
            break
        fi
    done
done
