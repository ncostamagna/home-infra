# Setup

- first install cilium
- then argocd

```
minikube addons enable ingress
```
- install minikube in 01-setup

# Cilium

```sh
# add repo
helm repo add cilium https://helm.cilium.io/

helm pull cilium/cilium --untar

# create file
# helm show values cilium/cilium > ./cilium/values.yaml

helm install cilium ./cilium --namespace kube-system -f ./cilium/values.yaml --create-namespace

helm upgrade --install cilium ./cilium -n kube-system --set ipv4NativeRoutingCIDR=10.0.0.0/8 --set ipMasqAgent.enabled=false --set bpf.masquerade=true                      
```

# Argo

```sh
# in 99-argo/manifest
kubectl apply -k . --server-side  
```

local pass: 1O4FdHi5zU5b7-1N


```yaml
# passit back example
project: default
source:
  repoURL: https://github.com/ncostamagna/home-infra
  path: passit-back
  targetRevision: HEAD
destination:
  server: https://kubernetes.default.svc
  namespace: axul
syncPolicy:
  automated:
    prune: true
    enabled: true

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
# Passit Back
```sh
helm install passit-back ./passit-back --create-namespace --namespace axul
helm upgrade passit-back ./passit-back --namespace axul
```

# Tunnel

```
minikube tunnel

# argo
https://argocd.127.0.0.1.nip.io/applications
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