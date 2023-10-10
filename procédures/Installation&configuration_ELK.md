# Installation de ElasticSearch 8.10.2

## Téléchargement
```
useradd -rs /bin/false elastic
cd /tmp
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.10.2-linux-x86_64.tar.gz
tar -xzvf elasticsearch-8.10.2-linux-x86_64.tar.gz
mv elasticsearch-8.10.2-linux-x86_64/ /opt/elasticsearch
chown -R elastic: /opt/elasticsearch 
```

## Configuration

Lancer une première fois elasticsearch, il configurera la sécurité, créera le mot de passe. Surtout, veillez à bien le sauvegarder, ainsi que le token pour kibana.

```
cd /opt/elasticsearch/bin/elasticsearch
```

Puis, on va configurer notre service pour systemd :

```
cd /etc/systemd/system
wget https://raw.githubusercontent.com/NonneTrapuE/brief_supervision/main/files/ELK/elastic.service
systemctl daemon-restart
systemctl enable --now elastic.service
```

