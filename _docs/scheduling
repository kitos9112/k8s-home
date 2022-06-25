# Kubernetes Node(s), Pod(s), and Storage Scheduling

Pods in Kubernetes can be scheduled or allocated in a node following a deterministic approach by leveraging `nodeSelection` and `nodeAffinity` fields in the `Pod` resource of any Kubernetes replicaSet controller (e.g. deployment).

This Kubernetes cluster spans two well-defined geographic delimitations; `internal` || `home`, and `external` || `cloud` node types. Each node is automatically labelled with a `node_locality` label that could be either `internal` or `external`. By taking this approach, some pods will feel more "affinity" to land in a specific node that matches a given label (e.g. `external`). Moreover, other also [well-known labels](https://kubernetes.io/docs/reference/labels-annotations-taints/#topologykubernetesiozone) like `topology.kubernetes.io/zone` are in use to facilitate Longhorn storage replica allocation.

The labeling process is taken care by the K3s Ansible role and should never be a manual task as it is prone to forgiveness.

More information about how Longhorn scheduling policy can be found [here](https://longhorn.io/docs/1.3.0/volumes-and-nodes/scheduling).