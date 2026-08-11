#!/bin/bash

set -e

echo "======================================"
echo " Installing AWS CLI v2"
echo "======================================"

echo "[1/5] Installing prerequisites..."

sudo apt-get update
sudo apt-get install -y curl unzip

echo "[2/5] Downloading AWS CLI v2..."

cd /tmp

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o awscliv2.zip

echo "[3/5] Extracting AWS CLI..."

rm -rf aws
unzip -q awscliv2.zip

echo "[4/5] Installing AWS CLI..."

sudo ./aws/install --update

echo "[5/5] Verifying installation..."

aws --version

echo
echo "======================================"
echo " AWS CLI installation completed"
echo "======================================"
