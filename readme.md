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
helm uninstall nats --namespace axul

helm install nats ./nats --namespace axul -f ./nats/values.yaml --create-namespace

helm upgrade nats ./nats --namespace axul -f ./nats/values.yaml --create-namespace

kubectl port-forward -n axul service/nats 4222:4222
```

# Nack
```sh
helm install nack ./nack --create-namespace --namespace axul
```

# Nats Initial
```sh
helm install nats-initial ./nats-initial --create-namespace --namespace axul
helm upgrade nats-initial ./nats-initial --create-namespace --namespace axul
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

# Version and Pull

```sh
# version
helm search repo nats/nack

# pull
helm pull nats/nack --untar --version 0.28.1
```