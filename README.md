# Bài 4: Chạy song song nhiều cổng dịch vụ (Nginx Virtual Hosts)

## Mục tiêu
Cấu hình Nginx chạy song song hai trang web tĩnh độc lập trên cùng một địa chỉ IP, phân biệt bằng cổng dịch vụ:

| Trang | Cổng | Thư mục root |
|---|---|---|
| Beta App | 8080 | `/var/www/beta-app/html/` |
| Internal App | 8090 | `/var/www/internal-app/html/` |

## Môi trường
- Nhà cung cấp VPS: azPVS (gói Cheap 2)
- Hệ điều hành: Ubuntu 22.04 LTS
- Web server: Nginx 1.18.0
- IP máy chủ: `160.187.229.76`

## Các file trong thư mục này
- `multi-port.conf`: cấu hình Nginx gồm 2 server block (đặt tại `/etc/nginx/sites-available/multi-port.conf`)
- `beta-app-index.html`: trang chủ Beta App (đặt tại `/var/www/beta-app/html/index.html`)
- `internal-app-index.html`: trang chủ Internal App (đặt tại `/var/www/internal-app/html/index.html`)

## Các bước thực hiện
1. Cài Nginx: `sudo apt install nginx -y`
2. Tạo hai thư mục mã nguồn: `sudo mkdir -p /var/www/beta-app/html /var/www/internal-app/html`
3. Tạo file `index.html` cho mỗi thư mục, phân quyền cho `www-data`.
4. Tạo file `/etc/nginx/sites-available/multi-port.conf`, bật bằng symlink vào `sites-enabled/`.
5. Kiểm tra cú pháp và nạp lại cấu hình: `sudo nginx -t && sudo systemctl reload nginx`
6. Mở cổng trên UFW:
   ```bash
   sudo ufw allow OpenSSH
   sudo ufw allow 8080/tcp
   sudo ufw allow 8090/tcp
   sudo ufw enable
   ```
7. Firewall của nhà cung cấp: trang quản trị azPVS không có mục Cloud Firewall riêng, nên chỉ dùng UFW. Đã kiểm tra truy cập từ internet vào cả hai cổng thành công.

## Kiểm tra
```bash
curl http://160.187.229.76:8080   # trả về trang Beta App
curl http://160.187.229.76:8090   # trả về trang Internal App
```

Kết quả: cổng 8080 trả về `Beta App - Trang kiểm thử ứng dụng (cổng 8080)`, cổng 8090 trả về `Internal App - Trang thông tin nội bộ (cổng 8090)`.