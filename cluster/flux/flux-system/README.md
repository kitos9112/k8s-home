# SSH Private Key Generation and configuration

## Generate new SSH key:

> ssh-keygen -t ecdsa -b 521 -C "github-deploy-key" -f ./cluster/github-deploy-key -q -P ""

Paste public key: https://github.com/kitos9112/k8s-home/settings/keys
Create sops secret in `cluster/flux/flux-system/github-deploy-key.sops.yaml` with the contents of:

```yaml
# yamllint disable
apiVersion: v1
kind: Secret
metadata:
    name: github-deploy-key
    namespace: flux-system
stringData:
    # Contents of: github-deploy-key
    # secretlint-disable
    # gitleaks-disable
    identity: |
        -----BEGIN OPENSSH PRIVATE KEY-----
            ...
        -----END OPENSSH PRIVATE KEY-----
    # secretlint-enable
    # Output of: curl --silent https://api.github.com/meta | jq --raw-output '"github.com "+.ssh_keys[]'
    known_hosts: |
        github.com ssh-ed25519 ...
        github.com ecdsa-sha2-nistp256 ...
        github.com ssh-rsa ...
```

Encrypt secret:

> sops --encrypt --in-place ./cluster/flux/flux-system/github-deploy-key.sops.yaml

Apply secret to cluster:

> sops -d cluster/flux/flux-system/github-deploy-key.sops.yaml | kubectl apply -f -

Update cluster/base/flux-system/gotk-sync.yaml:

```yaml
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: flux-system
  namespace: flux-system
spec:
  interval: 5m0s
  url: ssh://git@github.com/kitos9112/k8s-home
  ref:
    branch: next
  secretRef:
    name: github-deploy-key
```

Commit and push changes
Verify git repository is now using SSH:

> kubectl get gitrepository -n flux-system