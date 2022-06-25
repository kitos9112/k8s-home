# Base

Serves as entrypoint to [FluxCD](https://fluxcd.io/docs/) thereby declaring all other cluster components.

In addition, [Flux system sources](./cluster/base/flux-system/sources) contain either GitRepositories and HelmRepositories Custom Resources Definitions (CRDs) that are used as a common interface for artifact acquisition from within the cluster itself. The other `gotk` components and `sync` manifests are deployed upon cluster initialisation once and maintained up-to-date via a custom [GitHub Actions workflow](https://github.com/kitos9112/k8s-home/tree/main/.github/workflows/schedule-flux-update.yaml) thereafter.
