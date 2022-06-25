# CRDS (Custom Resource Definitions)

From [Kubernetes custom resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources)
> A custom resource is an extension of the Kubernetes API that is not necessarily available in a default Kubernetes installation. It represents a customization of a particular Kubernetes installation. However, many core Kubernetes functions are now built using custom resources, making Kubernetes more modular.

This directory contains `Custom Resource Definitions (CRDs)` for all underpinned K8s applications installed in the cluster (e.g. `alertmanagerconfigs.monitoring.coreos.com`)

**These must always be deployed in the first place**, and all other cluster categories (e.g. core, apps) depend on them. Basically, a simple change in one of the CRDs triggers a full cluster re-conciliation.
