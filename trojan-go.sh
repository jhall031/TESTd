#!/bin/bash
# Trojan Go Auto Setup 
# =========================

# Installing Wget & Curl
apt update -y
apt upgrade -y
apt install wget -y
apt install screen -y
apt install curl -y
apt install zip

# Domain # Silakan Berpikir Sendri caranya
domen=l2w9.djas.my.id

# Installing Trojan Go
mkdir -p /etc/trojan-go-mini/
chmod 755 /etc/trojan-go-mini/
touch /etc/trojan-go-mini/trojan-go.pid
wget -O /usr/bin/trojan-go-mini https://wildyproject.net/Script/trojan-go/trojan-go
wget -O /usr/bin/geoip.dat https://wildyproject.net/Script/trojan-go/geoip.dat
wget -O /usr/bin/geosite.dat https://wildyproject.net/Script/trojan-go/geosite.dat
chmod +x /usr/bin/trojan-go-mini

# Service
cat > /etc/systemd/system/trojan-go-mini.service << END
[Unit]
Description=Trojan-Go Mini Service
Documentation=https://p4gefau1t.github.io/trojan-go/
Documentation=https://github.com/trojan-gfw/trojan
Documentation=https://wildyproject.net
After=network.target

[Service]
Type=simple
PIDFile=/etc/trojan-go-mini/trojan-go.pid
ExecStart=/usr/bin/trojan-go-mini -config /etc/trojan-go-mini/config.json
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartSec=10
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

# Config
cat > /etc/trojan-go-mini/config.json << END
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 443, # Port Untuk Trojan-Go
    "remote_addr": "127.0.0.1",
    "remote_port": 85, # Port Nginx / Apache ( Wajib Ada )
    "password": [
        "PasswordClient" # Semua Password Client
    ],
    "ssl": {
        "cert": "/etc/trojan-go-mini/cert.crt", # Path Certificate
        "key": "/etc/trojan-go-mini/cert.key", # Path Certificate Key
        "sni": "l2w9.wildystore.my.id" # Domain Name ( Harus Sama Dengan Cert )
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/usr/bin/geoip.dat",
        "geosite": "/usr/bin/geosite.dat"
    }
}
END

# Starting
systemctl daemon-reload
systemctl enable trojan-go-mini
systemctl start trojan-go-mini


#path cert /etc/trojan-go-mini/cert.crt