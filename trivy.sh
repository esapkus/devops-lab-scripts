#!/bin/bash

set -e

echo "========================================"
echo "Installing Trivy"
echo "========================================"

# Check if already installed
if command -v trivy >/dev/null 2>&1; then
    echo "Trivy is already installed."
    trivy --version
    exit 0
fi

echo "[1/5] Removing old Trivy repository if present..."

sudo rm -f /etc/apt/sources.list.d/trivy.list
sudo rm -f /etc/apt/keyrings/trivy.gpg

echo "[2/5] Installing prerequisites..."

sudo apt-get update
sudo apt-get install -y wget gnupg apt-transport-https ca-certificates

echo "[3/5] Adding Trivy repository..."

sudo mkdir -p /etc/apt/keyrings

wget -qO- https://aquasecurity.github.io/trivy-repo/deb/public.key \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/trivy.gpg > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
    | sudo tee /etc/apt/sources.list.d/trivy.list > /dev/null

echo "[4/5] Installing Trivy..."

sudo apt-get update
sudo apt-get install -y trivy

echo "[5/5] Verifying installation..."

trivy --version

echo "========================================"
echo "Trivy installation completed"
echo "========================================"
