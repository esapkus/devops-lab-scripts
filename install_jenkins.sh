#!/bin/bash
set -e

echo "========================================="
echo "Installing Jenkins on Ubuntu"
echo "========================================="

# Remove any previous Jenkins repository/key (safe on fresh EC2 too)
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /etc/apt/keyrings/jenkins-keyring.asc
sudo rm -f /usr/share/keyrings/jenkins-keyring.*

echo "[1/8] Updating package index..."
sudo apt update

echo "[2/8] Installing prerequisites..."
sudo apt install -y \
    openjdk-21-jdk \
    curl \
    wget \
    gnupg \
    ca-certificates

echo "[3/8] Creating keyring directory..."
sudo mkdir -p /etc/apt/keyrings

echo "[4/8] Downloading Jenkins signing key..."
sudo wget -qO /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

echo "[5/8] Adding Jenkins repository..."
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
sudo tee /etc/apt/sources.list.d/jenkins.list >/dev/null

echo "[6/8] Updating package index..."
sudo apt update

echo "[7/8] Installing Jenkins..."
sudo apt install -y jenkins

echo "[8/8] Enabling and starting Jenkins..."
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo
echo "========================================="
echo "Jenkins Installation Completed"
echo "========================================="

echo
echo "Java Version:"
java -version

echo
echo "Jenkins Version:"
jenkins --version || true

echo
echo "Jenkins Status:"
sudo systemctl --no-pager status jenkins

echo
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com || true)
if [ -n "$PUBLIC_IP" ]; then
    echo "Open Jenkins at:"
    echo "http://${PUBLIC_IP}:8080"
fi
