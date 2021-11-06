# Ingress Objects

## Securing/Protecting Ingress Resources

All ingress objects exposed by this cluster use `cert-manager` to request and manage SSL/TLS certificates. Thus, all ingress objects are annotated with the `cert-manager.io/cluster-issue` annotation in order to automatically generate a certificate stored as a secret for the ingress object.

Likewise, most ingress resources are protected with a custom `middleware` layer that will force authentication via Google IDP. This is performed with the `traefik-forward-auth`