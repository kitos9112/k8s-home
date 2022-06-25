# K3[8]S @ HOME OPS

---

[![k3s](https://img.shields.io/badge/k3s-v1.23.7-brightgreen?style=for-the-badge&logo=kubernetes&logoColor=white)](https://k3s.io/)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white&style=for-the-badge)](https://github.com/pre-commit/pre-commit)
[![renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot&logoColor=white)](https://github.com/renovatebot/renovate)
[![Lines of code](https://img.shields.io/tokei/lines/github/kitos9112/k8s-home?style=for-the-badge&color=brightgreen&label=lines&logo=codefactor&logoColor=white)](https://github.com/kitos9112/k8s-home/graphs/contributors)
![GitHub repo size](https://img.shields.io/github/repo-size/kitos9112/k8s-home)

---

This repo contains my `home` infrastructure defined as Kubernetes helm releases, CRDs, and other set of helper scripts deployed via FluxCD.
The underlying infrastructure is maintained through a whole personal (still private) arsenal of Ansible playbooks and roles to automate my home setup.

I am a firm believer in GitOps and Kubernetes as the defacto cloud orchestrator for running everything as containers in the private and public clouds alike.

## 🧬 Repository structure

The cluster components break down all their services into **6** well-defined "categories" under the [cluster](https://github.com/kitos9112/k8s-home/tree/main/cluster) directory:

- [base](https://github.com/kitos9112/k8s-home/tree/main/cluster/base)
- [sources](https://github.com/kitos9112/k8s-home/tree/main/cluster/sources)
- [crds](https://github.com/kitos9112/k8s-home/tree/main/cluster/crds)
- [core](https://github.com/kitos9112/k8s-home/tree/main/cluster/core)
- [apps](https://github.com/kitos9112/k8s-home/tree/main/cluster/apps)
- [config](https://github.com/kitos9112/k8s-home/tree/main/cluster/config)
s
### 🍳 GitOps

Flux watches the aforementioned cluster folders in the `main` Git branch. Also, it makes the appropriate changes in the K8s cluster based on the Kustomization and Helm controllers specifications.

### 🤖 RenovateBot

Med Renovate watches the **entire repository** looking for dependency updates, when they are found, a Pull Request is automatically created (and auto-applied oftentimes).

Personally, I use a Github app under the name of `Henrry PA` that kindly assist me with the PR creation, and fillings.

## 🔧 Hardware

| Device                   | Count | OS Disk Size  | Data Disk Size        | CPU             | Ram   | Operating System | Purpose              |
| ------------------------ | ----- | ------------- | --------------------- | --------------- | ----- | ---------------- | -------------------- |
| Raspberry Pi 4B+         | 1     | 256GB SSD     | N/A                   | BCM2711         | 8GB   | RaspberryOS      | K3s worker && Master |
| Beelink U5900            | 1     | 512GB M.2 SSD | 500GB HDD             | Intel N5095     | 16GB  | Ubuntu 22.04     | K3s Master && Worker |
| Dell Optiplex 7070 Micro | 1     | 512GB M.2 SSD | 480GB SSD             | Intel i5-8500T  | 16GB  | Ubuntu 22.04     | K3s Master && Worker |
| Trigkey Green G1 MiniPC  | 1     | 256GB M.2 SSD | 500GB HDD             | Intel J4125     | 8GB   | Ubuntu 22.04     | K3s worker           |
| Dell Precision 3510      | 1     | 2TB M.2 SSD   | 500GB HDD + 500GB SSD | Intel i7-6800HQ | 32 GB | Ubuntu 22.04     | K3s worker           |
| Raspberry Pi 4B+         | 3     | 256GB SSD     | N/A                   | BCM2711         | 4GB   | RaspberryOS      | K3s workers          |


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

After the aforementioned command is fired off against a nuked cluster, the cluster bootstrapping logic should take place starting with CRDs, sources, and config categories, them moving to core items, whilst finalising with the apps objects.

## Uninstall FluxCD alongside all CRDs

The following CLI command will uninstall FluxCD alongside all CRDs:

```sh
flux uninstall --resources --crds --namespace=flux-system
```

## Troubleshooting - NOT YET IMPLEMENTED (WIP)

A dedicated directory with a set of `runbooks` should live under /docs/troubleshooting.

## Frequently Answered Questions (FAQ)

### Why do K8s namespaces live in a single folder?

This is quite important.
Despite adding extra management overhead, it ensures the namespace **must exist before deploying any K8s objects**.

## Credits :handshake:&nbsp;

A high representation as well as inspiration of this repository came from the following three sources predominantly:

- [onedr0p/home-cluster](https://github.com/onedr0p/home-cluster)
- [carpenike/k8s-gitops](https://github.com/carpenike/k8s-gitops)
- [billimek/k8s-gitops](https://github.com/billimek/k8s-gitops)
