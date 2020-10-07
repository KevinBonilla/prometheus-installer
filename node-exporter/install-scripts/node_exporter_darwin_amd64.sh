#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.darwin-amd64.tar.gz
tar -xvzf node_exporter-1.0.1.darwin-amd64.tar.gz

mv node_exporter-1.0.1.darwin-amd64/node_exporter /usr/local/bin

rm -rf nnode_exporter-1.0.1.darwin-amd64*

cd ~/tmp
rm -rf install-scripts/

