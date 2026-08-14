#!/bin/bash

set -e

echo "======================================"
echo " Installing kubectl"
echo "======================================"

echo "[1/5] Checking system architecture..."

ARCH=$(dpkg --print-architecture)

if [ "$ARCH" != "amd64" ]; then
    echo "ERROR: This script is designed for amd64/x86_64."
    echo "Detected architecture: $ARCH"
    exit 1
fi

echo "Architecture: $ARCH"

echo "[2/5] Installing prerequisites..."

sudo apt-get update
sudo apt-get install -y curl ca-certificates

echo "[3/5] Downloading latest stable kubectl..."

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

echo "Latest stable version: $KUBECTL_VERSION"

curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

echo "[4/5] Installing kubectl..."

chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

echo "[5/5] Verifying installation..."

kubectl version --client

echo
echo "======================================"
echo " kubectl installation completed"
echo "======================================"

echo
echo "Installed version:"
kubectl version --client
