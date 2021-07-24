# K8S @ HOME

This repo contains my home infrastructure defined as Kubernetes manifests and other helper scripts.
I am a firm believer in GitOps and Kubernetes as the defacto cloud orchestrator.

## Services running in the cluster

The cluster breaks down all its services into **three** well-defined categories:

1. base
2. core
3. crds


## Bootstrap cluster using Flux

```sh
flux bootstrap github --branch=master \
                      --personal \
                      --repository=k8s-home \
                      --owner=kitos9112 \
                      --interval=30s \
                      --path=./cluster/uk.msrpi.com \
                      --token-auth
```

After the aforementioned command is fired off from a nuked cluster, some stuff will fail and requires manual intervention:

 1- Create a `monitoring`, `minio`, and `home-assistant` namespaces: `kubectl create ns monitoring; kubectl create ns minio; kubectl create ns home-assistant`

 2- Apply all flux system extra helm chart sources: `kubectl apply -f ./cluster/uk.msrpi.com/flux-system-extra/helm-chart-repositories`

 3- Install the `sealed secrets` chart by applying its kustomization: `kubectl apply -k ./cluster/uk.msrpi.com/kube-system/sealed-secrets/`

 4- Apply all the secrets after re-running `hack/secrests write`: `kubectl apply -k ./cluster/uk.msrpi.com/secrets/`


## Handle secrets using Bitnami kubesealed controller
#TODO

## Uninstall FluxCD alongside all CRDs

```sh
flux uninstall --resources --crds --namespace=flux-system
```

## Troubleshootiung

### DNS investigation

Install a tshoot pod from where commands can be triggered

```
kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml
```
