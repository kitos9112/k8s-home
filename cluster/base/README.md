# Base

Serves as entrypoint to [FluxCD](https://fluxcd.io/docs/) thereby declaring all other cluster components through GitOps methodologies.

There are `gotk` components and `sync` manifests are deployed upon cluster initialisation once and maintained up-to-date via a custom [GitHub Actions workflow](https://github.com/kitos9112/k8s-home/tree/main/.github/workflows/schedule-flux-update.yaml) thereafter.
