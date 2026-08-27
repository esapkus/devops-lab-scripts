#!/bin/bash

set -e

echo "======================================"
echo " Installing Apache2"
echo "======================================"

echo
echo "==> Updating package index"
apt update

echo
echo "==> Installing Apache2"
apt install -y apache2

echo
echo "==> Enabling Apache2"
systemctl enable apache2

echo
echo "==> Starting Apache2"
systemctl start apache2

echo
echo "==> Checking Apache2 status"
systemctl --no-pager status apache2

echo
echo "==> Apache version"
apache2 -v

echo
echo "==> Listening ports"
ss -lntp | grep ':80' || true

echo
echo "==> Testing HTTP response"
curl -I http://localhost

echo
echo "======================================"
echo " Apache2 Installation Completed"
echo "======================================"
