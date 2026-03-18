#!/bin/bash
# Run once to create the tunnel and register DNS entries.
# The credentials secret is NOT stored in git — run this script on your ThinkPad.

TUNNEL_NAME="home-infra"
DOMAIN="<YOUR-DOMAIN>"  # e.g. example.com

# 1. Login to Cloudflare (opens browser)
cloudflared tunnel login

# 2. Create the tunnel
cloudflared tunnel create $TUNNEL_NAME

# 3. Get the tunnel ID
TUNNEL_ID=$(cloudflared tunnel list | grep $TUNNEL_NAME | awk '{print $1}')
echo "Tunnel ID: $TUNNEL_ID"

# 4. Create Kubernetes secret with tunnel credentials
kubectl create namespace cloudflared --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic tunnel-credentials \
  --from-file=credentials.json=$HOME/.cloudflared/$TUNNEL_ID.json \
  -n cloudflared \
  --dry-run=client -o yaml | kubectl apply -f -

# 5. Register DNS entries (one per hostname)
cloudflared tunnel route dns $TUNNEL_NAME argocd.$DOMAIN
cloudflared tunnel route dns $TUNNEL_NAME passit.$DOMAIN

echo ""
echo "Done. Update <TUNNEL-ID> in configmap.yaml with: $TUNNEL_ID"
echo "Then: kubectl apply -f 01-setup/cloudflared/"
