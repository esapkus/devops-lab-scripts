#!/bin/bash

set -e

echo "========================================"
echo "Installing eksctl"
echo "========================================"

# Check if already installed
if command -v eksctl >/dev/null 2>&1; then
    echo "eksctl is already installed."
    eksctl version
    exit 0
fi

echo "[1/4] Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y curl tar

echo "[2/4] Downloading eksctl..."

ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
    PLATFORM="linux_amd64"
elif [ "$ARCH" = "aarch64" ]; then
    PLATFORM="linux_arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

curl --fail --location \
    "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz" \
    -o /tmp/eksctl.tar.gz

echo "[3/4] Installing eksctl..."

tar -xzf /tmp/eksctl.tar.gz -C /tmp

sudo mv /tmp/eksctl /usr/local/bin/eksctl

sudo chmod +x /usr/local/bin/eksctl

rm -f /tmp/eksctl.tar.gz

echo "[4/4] Verifying installation..."

eksctl version

echo "========================================"
echo "eksctl installation completed"
echo "========================================"
