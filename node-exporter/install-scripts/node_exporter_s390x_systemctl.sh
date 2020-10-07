#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-s390x.tar.gz
tar -xvzf node_exporter-1.0.1.linux-s390x.tar.gz

mv node_exporter-1.0.1.linux-s390x/node_exporter /usr/local/bin

rm -rf node_exporter-1.0.1.linux-s390x*

useradd -rs /bin/false node_exporter

cd /etc/systemd/system/

echo "[Unit]
Description=Node Exporter
After=network.target
 
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
 
[Install]
WantedBy=multi-user.target" > node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

cd ~/tmp
rm -rf install-scripts/
