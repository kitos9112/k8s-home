# K3[8]S @ HOME OPS

[![k3s](https://img.shields.io/badge/k3s-v1.22.6-brightgreen?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot&logoColor=white)](https://github.com/renovatebot/renovate)
[![Lines of code](https://img.shields.io/tokei/lines/github/kitos9112/k8s-home?style=for-the-badge&color=brightgreen&label=lines&logo=codefactor&logoColor=white)](https://github.com/kitos9112/k8s-home/graphs/contributors)

![GitHub repo size](https://img.shields.io/github/repo-size/kitos9112/k8s-home)

This repo contains my home infrastructure defined as Kubernetes manifests and other set of helper scripts deployed via FluxCD. The underlying infrastructure is also maintained through a whole personal (still private) arsenal of Ansible playbooks and roles to automate my home setup.

I am a firm believer in GitOps and Kubernetes as the defacto cloud orchestrator for running everything as containers in the private and public clouds alike.

## Repository structure

The cluster components break down all its services into **four** well-defined categories:

- [base](./base)

Serves as entrypoint to [FluxCD](https://fluxcd.io/docs/) thus a declaration to the other components.

Cluster-wide [secrets](./cluster/base/cluster-secrets.yaml) and [settings](./cluster/base/cluster-settings.yaml) employed in more than one place live in this category. They are leveraged in combination with [Flux variable substitution features](https://fluxcd.io/docs/components/kustomize/kustomization/#variable-substitution) which emulates bash string replacements as if they were executed on a terminal.

```sh
${var:=default}
${var:position}
${var:position:length}
${var/substring/replacement}

# Note that the name of a variable can contain only alphanumeric and underscore characters.
# The Kustomization controller validates the var names using this regular expression:
#   ^[_[:alpha:]][_[:alpha:][:digit:]]*$.
```

In addition, [Flux system sources](./cluster/base/flux-system/sources) contain either GitRepositories and HelmRepositories Custom Resources Definitions (CRDs) that are used as a common interface for artifact acquisition from within the cluster itself. The other `gotk` components and `sync` manifests are deployed upon cluster initialisation once and maintained up-to-date via a custom [GitHub Actions workflow](.github/workflows/flux-schedule.yaml) thereafter.

- [crds](./crds)

Contains Custom Resource Definitions (CRDs) for several K8s applications used in the cluster (e.g. `alertmanagerconfigs.monitoring.coreos.com`)
They must be deployed in the first place, and all other listed-below categories depend on them. This basically means that a simple change in one of the CRDs will require a full cluster reconcialiation.

- [core](./core)

It is made up of applications that become the heart and the foundation of any Kubernetes cluster to fullfil needs as:

- Storage
- Namespace declaration
- Certificate management
- Secret Management
- Monitoring and Observability
- Networking and Load Balancing
- Auto-os K8s worker upgrade
- K8s manifests and Persistent Volume Backup and Restore

They all ensure a well-maintained and secure Kubernetes cluster, each application fulfils a single cause and gets deployed onto its own namespace.
Also, they all depend on **crds** and Flux should never prune them in case a manifest disappears from the source of truth (e.g. Git)

> Each category contains a directory that depicts the Kubernetes namespace where to deploy `kustomize` objects.

- [apps](./apps)

All the actual containerised applications that run in my K8s home cluster, following the same approach as the core category.
Not many applications have yet landed here. They also depend on **core** and inherently **cdrs**, but Flux will prune resources here if they are not tracked by Git anymore.

## Bootstrap cluster using Flux

```sh
flux bootstrap github --branch=main \
                      --components-extra=image-reflector-controller,\
                        image-automation-controller \
                      --personal \
                      --repository=k8s-home \
                      --owner=kitos9112 \
                      --interval=30s \
                      --path=./cluster/base \
                      --token-auth
```

After the aforementioned command is fired off against a nuked cluster, the cluster bootstrapping logic should take place starting with CRDs objects, them moving to core items, and finalising with the apps objects.

## Uninstall FluxCD alongside all CRDs

The following CLI command will uninstall FluxCD alongside all CRDs:

```sh
flux uninstall --resources --crds --namespace=flux-system
```

## Troubleshooting - NOT YET IMPLEMENTED (WIP)

A dedicated directory with a set of `runbooks` should live under /docs/troubleshooting.

## Frequently Answered Questions (FAQ)

### Why do K8s namespaces live in a single folder?

This is quite important despite adding extra management overhead as it ensures the namespace must exist before deploying any K8s objects.

## Credits :handshake:&nbsp;

A high representation as well as inspiration of this repository came from the following three sources predominantly:

- [onedr0p/home-cluster](https://github.com/onedr0p/home-cluster)
- [carpenike/k8s-gitops](https://github.com/carpenike/k8s-gitops)
- [billimek/k8s-gitops](https://github.com/billimek/k8s-gitops)
