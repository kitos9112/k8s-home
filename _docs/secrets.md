# Secrets engines for K8s-home GitOps

This K3s cluster relies in the integration of FluxCD with Mozilla SOPS for bootstraping purposes. The following two tools are assumed to exist in the development environment

- gnupg
- flux

## GnuPG Keys

export FLUX_KEY_NAME="K8s Home msrpi.com (Flux) <marcos.soutullo91@gmail.com>"

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Real: ${FLUX_KEY_NAME}
EOF

gpg --list-secret-keys "${PERSONAL_KEY_NAME}"
# pub   rsa4096 2021-03-11 [SC]
#       772154FFF783DE317KLCA0EC77149AC618D75581
# uid           [ultimate] k8s@home (Macbook) <k8s-at-home@gmail.com>
# sub   rsa4096 2021-03-11 [E]

export FLUX_KEY_FP=C2C7D852AA45C7B41C440A772141D0D63053C652

gpg --export-secret-keys --armor "${FLUX_KEY_FP}" |
kubectl create secret generic sops-gpg \
--namespace=flux-system \
--from-file=sops.asc=/dev/stdin

