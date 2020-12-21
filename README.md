# K8S @ HOME

This repo contains my home infrastructure defined as Kubernetes manifests and other helper scripts.
I am a firm believe in GitOps and Kubernetes as the defacto cloud orchestrator.

## Bootstrap cluster using Flux

```sh
export GITHUB_TOKEN=0b4c09c596f1
flux bootstrap github --arch arm64 \
                      --branch master \
                      --cluster-domain uk.msrpi.com \
                      --personal \
                      --repository=k8s-home \
                      --owner=kitos9112 \
                      --path=./cluster
```
