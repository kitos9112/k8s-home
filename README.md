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

After the aforementioned command is fired off from a nuked cluster, some stuff will fail and requires manual intervention:
 1- Create a `monitoring` namespace: `kubectl create ns monitoring`
 2- Apply all flux system extra helm chart sources: `kubectl apply -f ./cluster/uk.msrpi.com/flux-system-extra/helm-chart-repositories`

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
