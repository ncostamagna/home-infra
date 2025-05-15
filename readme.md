# Setup

# Cilium
```sh
helm install cilium ./cilium --namespace kube-system -f ./cilium/values.yaml --create-namespace
```


# NATS
```sh
helm install nats ./nats --namespace axul -f ./nats/values.yaml --create-namespace
```