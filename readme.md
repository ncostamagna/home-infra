# Setup
```
minikube addons enable ingress
```

# Cilium
```sh
helm install cilium ./cilium --namespace kube-system -f ./cilium/values.yaml --create-namespace
```


# NATS
```sh
helm install nats ./nats --namespace axul -f ./nats/values.yaml --create-namespace
```

# Nats Back
```sh
helm install axul-nats-back ./axul-nats --create-namespace --namespace axul
```

# Tunnel

```
minikube tunnel
```

```sh
http://127.0.0.1:8080/send
```