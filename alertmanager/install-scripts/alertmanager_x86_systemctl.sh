#!bin/bash
cd /opt/
wget https://github.com/prometheus/alertmanager/releases/download/v0.18.0/alertmanager-0.18.0.linux-amd64.tar.gz
tar -xvzf alertmanager*.tar.gz
mv alertmanager*/alertmanager /usr/local/bin
mkdir /etc/alertmanager/
echo "global:


# The directory from which notification templates are read.
templates:
- '/etc/alertmanager/template/*.tmpl'

# The root route on which each incoming alert enters.
route:
  # The labels by which incoming alerts are grouped together. For example,
  # multiple alerts coming in for cluster=A and alertname=LatencyHigh would
  # be batched into a single group.
  group_by: ['alertname', 'cluster', 'service']

  # When a new group of alerts is created by an incoming alert, wait at
  # least 'group_wait' to send the initial notification.
  # This way ensures that you get multiple alerts for the same group that start
  # firing shortly after another are batched together on the first
  # notification.
  group_wait: 3s

  # When the first notification was sent, wait 'group_interval' to send a batch
  # of new alerts that started firing for that group.
  group_interval: 5s

  # If an alert has successfully been sent, wait 'repeat_interval' to
  # resend them.
  repeat_interval: 1m

  # A default receiver
  receiver: mail-receiver

  # All the above attributes are inherited by all child routes and can
  # overwritten on each.

  # The child route trees.
  routes:
  - match:
      service: node
    receiver: mail-receiver

    routes:
    - match:
        severity: critical
      receiver: critical-mail-receiver

  # This route handles all alerts coming from a database service. If there's
  # no team to handle it, it defaults to the DB team.
  - match:
      service: database
    receiver: mail-receiver

    routes:
    - match:
        severity: critical
      receiver: critical-mail-receiver


receivers:
- name: 'mail-receiver'
  slack_configs:
  - api_url: 
    channel: '#rt-infra-machines'

- name: 'critical-mail-receiver'
  slack_configs:
  - api_url: 
    channel: '#rt-infra-machines'" > alertmanager.yml


cd /etc/systemd/system/

echo "[Unit]
Description=AlertManager Server Service
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=Simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.tsdb.path /var/lib/alertmanager

[Install]
WantedBy=multi-user.target" > alertmanager.service

systemctl daemon-reload
systemctl start alertmanager
systemctl enable alertmanager

cd ~/
rm -f alertmanager_*.sh
