
[![k3s](https://img.shields.io/badge/k3s-v1.22.4-brightgreen?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot&logoColor=white)](https://github.com/renovatebot/renovate)
[![Lines of code](https://img.shields.io/tokei/lines/github/kitos9112/k8s-home?style=for-the-badge&color=brightgreen&label=lines&logo=codefactor&logoColor=white)](https://github.com/kitos9112/k8s-home/graphs/contributors)

# K3[8]S @ HOME

This repo contains my home infrastructure defined as Kubernetes manifests and other set of helper scripts deployed via FluxCD. It will also shortly contain a whole personal arsenal of Ansible playbooks and roles to automate my home setup.

I am a firm believer in GitOps and Kubernetes as the defacto cloud orchestrator for running everything as containers.

## Repository structure

The cluster breaks down all its services into **four** well-defined categories:

1. [base](./base)

Serves as entrypoint to [FluxCD](https://fluxcd.io/docs/) thus a declaration to the other components.

Cluster-wide [secrets](./cluster/base/cluster-secrets.yaml) and [settings](./cluster/base/cluster-settings.yaml) employed in more than one place live in [cluster-secrets.yaml] and they are leveraged in combination with [Variable Substitution features](https://fluxcd.io/docs/components/kustomize/kustomization/#variable-substitution) which emulates bash string replacements.

```sh
${var:=default}
${var:position}
${var:position:length}
${var/substring/replacement}

# Note that the name of a variable can contain only alphanumeric and underscore characters.
# The Kustomization controller validates the var names using this regular expression: ^[_[:alpha:]][_[:alpha:][:digit:]]*$.
```

[Flux system sources](./cluster/base/flux-system/sources) contain either GitRepositories or HelmRepositories custom resources that are used as common interface for artifact acquisition.

2. [crds](./crds)

Contains Custom Resource Definitions (CRDs) for several K8s applications used in the cluster (e.g. `alertmanagerconfigs.monitoring.coreos.com`)
They are mandatory to be deployed in the first place, and all other listed-below categories depend on this.

3. [core](./core)

Made up of applications that become the heart and the foundation of any Kubernetes cluster to fullfil needs as:

- Storage
- Namespace declatation
- Certificate manager
- Monitoring and Observability
- Networking
- Auto-os K8s worker upgrade
- Backup and restore

They all ensure a well maintained and secure Kubernetes cluster, each application is deployed in its own namespace.
It depends on **crds** and Flux should never prune them.

> Each category contains a directory that depicts the Kubernetes namespace where to deploy `kustomize` objects.

4. [apps](./apps)

All the actual containerised applications that run in my K8s home cluster, following the same approach as the core category. Flux will prune resources here if they are not tracked by Git anymore
It depends on **core**

## Bootstrap cluster using Flux

```sh
flux bootstrap github --branch=main \
                      --personal \
                      --repository=k8s-home \
                      --owner=kitos9112 \
                      --interval=30s \
                      --path=./cluster/base \
                      --token-auth
```

After the aforementioned command is fired off on a nuked cluster, some deployments might fail and require manual intervention

## Uninstall FluxCD alongside all CRDs

The following CLI command will uninstall FluxCD alongside all CRDs:

```sh
flux uninstall --resources --crds --namespace=flux-system
```

## Troubleshooting

A dedicated directory with a set of runbooks should live under /docs/troubleshooting. NOT YET IMPLEMENTED.

### DNS investigation

Install a short-lived pod from where commands can be triggered

```sh
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
```

## Frequently Answered Questions (FAQ)

### Why do K8s namespaces live in a single folder?

This is quite important despite adding extra management overhead as it ensures the namespace must exist before deploying any K8s objects.

## Credits :handshake:&nbsp;

A high representation of this repository came from the following two sources predominantly:

- [onedr0p/home-cluster](https://github.com/onedr0p/home-cluster)
- [carpenike/k8s-gitops](https://github.com/carpenike/k8s-gitops)
- [billimek/k8s-gitops](https://github.com/billimek/k8s-gitops)
