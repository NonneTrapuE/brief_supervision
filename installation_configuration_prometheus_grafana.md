# Installation Prometheus

Installation Prometheus Node Exporter version 1.6.1

```
useradd -rs /bin/false node_exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.darwin-amd64.tar.gz
tar -xavf node_exporter-1.6.1.linux-amd64.tar.gz
mkdir /opt/Prometheus
mv node_exporter-1.6.1.linux-amd64/node_exporter /opt/Prometheus/node_exporter
chown -R /opt/Prometheus
chmod -R 700 /opt/Prometheus
```

Configuration Prometheus Node Exporter

```

