#!/bin/bash

set -e

echo "======================================"
echo " Installing Helm"
echo "======================================"

echo "[1/5] Installing prerequisites..."

sudo apt-get update
sudo apt-get install -y curl gpg apt-transport-https

echo "[2/5] Adding Helm repository..."

HELM_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
    -o /tmp/helm.gpg

echo "Verifying Helm signing key..."

KEY_ID=$(gpg --show-keys --with-colons /tmp/helm.gpg \
    | awk -F: '$1 == "fpr" {print $10}' | head -n 1)

if [ "$KEY_ID" != "$HELM_KEY_ID" ]; then
    echo "ERROR: Helm signing key verification failed."
    exit 1
fi

sudo mkdir -p /usr/share/keyrings

gpg --dearmor < /tmp/helm.gpg \
    | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
    | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null

rm -f /tmp/helm.gpg

echo "[3/5] Updating package index..."

sudo apt-get update

echo "[4/5] Installing Helm..."

sudo apt-get install -y helm

echo "[5/5] Verifying installation..."

helm version

echo
echo "======================================"
echo " Helm installation completed"
echo "======================================"
