# Setup

- first install cilium
- then argocd

```
minikube addons enable ingress
```
- install minikube in 01-setup

if you have errors with argocd, delete the pod: `pod/argocd-repo-server-[id]`
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

# Istio

```sh
helm install istio-base ./base -n istio-system --create-namespace                                    
helm install istiod ./istiod -n istio-system          
helm install istio-ingressgateway ./gateway -n istio-system
```


# Argo

```sh
# in 99-argo/manifest
kubectl apply -k . --server-side  
```

local pass: 1O4FdHi5zU5b7-1N

# Cert Local
```
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes -subj "/CN=passit.127.0.0.1.nip.io"

kubectl create secret tls passit-front-tls --cert=cert.pem --key=key.pem -n istio-system
```

# ClaudeFlare Tunnel

```sh
# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-public-v2.gpg | sudo tee /usr/share/keyrings/cloudflare-public-v2.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-public-v2.gpg] https://pkg.cloudflare.com/cloudflared any main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared

# Setup
# NO sudo cloudflared service install [token]

cloudflared tunnel login
cloudflared tunnel delete home-infra   # delete via UI  
cloudflared tunnel create home-infra   

kubectl apply -f 01-setup/cloudflare/namespace.yaml
kubectl apply -f 01-setup/cloudflare/secret.yaml
kubectl apply -f 01-setup/cloudflare/deployment.yaml

cloudflared tunnel route dns home-infra ecommerce-bo.ncostamagna.com

kubectl create secret generic tunnel-credentials --from-file=credentials.json=$HOME/.cloudflared/{id}.json -n cloudflared
```

# Vault

```sh
# vault setup
kubectl exec -it devops-shared-svc-vault-0 -n vault -- vault operator init

# if the pod fail delete the pod and the volume
kubectl delete pvc -n vault -l app.kubernetes.io/name=vault
kubectl delete pod devops-shared-svc-vault-0 -n vault

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

# Server

```sh
ssh nahuel@192.168.0.115
```