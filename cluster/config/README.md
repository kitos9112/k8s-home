# Config

This section offers cluster-wide [secrets](https://github.com/kitos9112/k8s-home/tree/main/cluster/config/cluster-secrets.sops.yaml) and [settings](https://github.com/kitos9112/k8s-home/tree/main/cluster/config/cluster-settings.yaml) available across all other cluster "categories" (e.g. apps). They are implemented in combination with [Flux variable substitution features](https://fluxcd.io/docs/components/kustomize/kustomization/#variable-substitution) which emulates bash string replacements as if they were executed on a terminal.

```sh
${var:=default}
${var:position}
${var:position:length}
${var/substring/replacement}

# Note that the name of a variable can contain only alphanumeric and underscore characters.
# The Kustomization controller validates the var names using this regular expression:
#   ^[_[:alpha:]][_[:alpha:][:digit:]]*$.
```

The values present in these configMaps get interpolated mostly in helmReleases values, but they can be used in any other flux-managed resources.
