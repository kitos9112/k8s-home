# Secrets engines for K8s-home GitOps

Plain-text files are easily stored and versioned in Git repositories, however, secrets are normally more tedious to deal with. My home K3s cluster relies on the integration of FluxCD with [Mozilla SOPS](https://fluxcd.io/docs/guides/mozilla-sops/).

Additionally, all secrets get locally encrypted using [age](https://github.com/FiloSottile/age), a simple alternative to [GPG](https://www.gnupg.org/). Make sure the following tools are installed on your local dev. environment:

```sh
brew install age fluxcd/tap/flux sops
```

