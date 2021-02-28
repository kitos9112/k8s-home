# K8S @ HOME

This repo contains my home infrastructure defined as Kubernetes manifests and other helper scripts.
I am a firm believer in GitOps and Kubernetes as the defacto cloud orchestrator.

## Services running in the cluster
#TODO

## Bootstrap cluster using Flux

```sh
flux bootstrap github --branch=master \
                      --personal \
                      --repository=k8s-home \
                      --owner=kitos9112 \
                      --path=./cluster/uk.msrpi.com
```

## Handle secrets using Bitnami kubesealed controller
#TODO

## Uninstall FluxCD alongside all CRDs

```sh
flux uninstall --resources --crds --namespace=flux-system
```
