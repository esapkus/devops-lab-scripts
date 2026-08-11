#!/bin/bash
set -e

echo "========================================="
echo " Installing Docker Engine"
echo "========================================="

echo "[1/7] Updating package index..."
sudo apt update

echo "[2/7] Installing prerequisites..."
sudo apt install -y ca-certificates curl

echo "[3/7] Removing old Docker packages if present..."
sudo apt remove -y docker.io docker-doc docker-compose docker-compose-v2 \
    podman-docker containerd runc 2>/dev/null || true

echo "[4/7] Adding Docker official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[5/7] Adding Docker official repository..."

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "[6/7] Installing Docker..."

sudo apt update

sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "[7/7] Starting Docker..."

sudo systemctl enable docker
sudo systemctl start docker

echo
echo "========================================="
echo " Docker Installation Completed"
echo "========================================="

echo
echo "Docker Version:"
sudo docker --version

echo
echo "Docker Compose Version:"
sudo docker compose version

echo
echo "Docker Service:"
sudo systemctl --no-pager --full status docker

echo
echo "Testing Docker..."

sudo docker run --rm hello-world

echo
echo "========================================="
echo " Docker is Ready!"
echo "========================================="
