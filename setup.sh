#!/bin/bash
# Chay: sudo bash setup.sh
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

echo "[1/6] Cai Nginx..."
apt update -y
apt install -y nginx curl
systemctl enable --now nginx

echo "[2/6] Tao thu muc va copy index.html..."
mkdir -p /var/www/beta-app/html /var/www/internal-app/html
cp "$DIR/beta-app/html/index.html" /var/www/beta-app/html/index.html
cp "$DIR/internal-app/html/index.html" /var/www/internal-app/html/index.html
chown -R www-data:www-data /var/www/beta-app /var/www/internal-app
chmod -R 755 /var/www/beta-app /var/www/internal-app

echo "[3/6] Cai cau hinh Nginx..."
cp "$DIR/multi-port.conf" /etc/nginx/sites-available/multi-port.conf
ln -sf /etc/nginx/sites-available/multi-port.conf /etc/nginx/sites-enabled/multi-port.conf

echo "[4/6] Kiem tra cu phap va reload..."
nginx -t
systemctl reload nginx

echo "[5/6] Cau hinh UFW..."
ufw allow OpenSSH
ufw allow 8080/tcp
ufw allow 8090/tcp
ufw --force enable
ufw status

echo "[6/6] Kiem tra noi bo..."
echo "--- Cong 8080 ---"; curl -s http://localhost:8080
echo "--- Cong 8090 ---"; curl -s http://localhost:8090

echo
echo "XONG. Nho mo cong 8080, 8090 tren Firewall cua azPVS (neu co)."
echo "Test tu ngoai: curl http://<IP_MAY_CHU>:8080  va  :8090"
