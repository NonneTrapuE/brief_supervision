# Node Exporter

## Installation Prometheus Node Exporter version 1.6.1

```
useradd -rs /bin/false node_exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.darwin-amd64.tar.gz
tar xavf node_exporter-1.6.1.linux-amd64.tar.gz
mkdir /opt/Prometheus
mv node_exporter-1.6.1.linux-amd64/node_exporter /opt/Prometheus/node_exporter
chown -R /opt/Prometheus
chmod -R 700 /opt/Prometheus
```

## Configuration Prometheus Node Exporter

```
cd /etc/systemd/system
wget https://raw.githubusercontent.com/NonneTrapuE/brief_supervision/main/node_exporter.service
mkdir /etc/node_exporter
touch /etc/node_exporter/configuration.yml
chmod -R 700 /etc/node_exporter
chown -R node_exporter: /etc/node_exporter
systemctl daemon-reload
systemctl enable --now node_exporter
```

On peut vérifier que le node exporter soit actif :

```
curl http://localhost:9100/metrics
```

L'authentification n'est pas disponible de base dans le node exporter. Il faut l'activer.

```
apt install --no-install-recommends apache2-utils
password=`openssl rand -base64 32`
passwordHashed=`echo ${password} | htpasswd -inBC 10 "" | tr -d ':\n'`
echo -e "basic_auth_users:\n\tprometheus: ${passwordHashed}" >> /etc/node_exporter/configuration.yml
systemctl restart node_exporter
```

⚠️ N'oubliez pas de récupérer le résultat de la variable **password** qui est le mot de passe en clair ⚠️


# Prometheus

## Installation de Prometheus

```
useradd -rs /bin/false prometheus
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz
tar xavf prometheus-2.47.1.linux-amd64.tar.gz
mv -R prometheus-2.47.1.linux-amd64/ /opt/prometheus/
```

## Configuration 

```
mkdir /etc/prometheus
cd /etc/prometheus
wget https://raw.githubusercontent.com/NonneTrapuE/brief_supervision/main/configuration.yml
chmod -R 700 /etc/prometheus
```

Fichier configuration.yml à modifier pour insérer les informations voulues

```
cd /etc/systemd/system
wget 
systemctl daemon-reload
systemctl enable --now prometheus
