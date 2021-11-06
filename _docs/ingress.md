#

## Securing Ingress Resources

All ingress objects exposed by this cluster use `cert-manager` to request and manage SSL/TLS certificates. Thus, all ingress objects are annotated with the `cert-manager.io/cluster-issue` annotation in order to automatically generate a certificate stored as a secret for the ingress object.