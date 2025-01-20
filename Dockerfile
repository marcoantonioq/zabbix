FROM ubuntu:24.04

ENV DB_PASSWORD=password

# Instalar dependências
RUN apt update && apt install -y ca-certificates net-tools sudo git wget locales

RUN locale-gen pt_BR.UTF-8 && update-locale LANG=pt_BR.UTF-8 LC_ALL=pt_BR.UTF-8

# Baixando e instalando o Zabbix Server
RUN wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb && \
  dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb && \
  apt update && DEBIAN_FRONTEND=noninteractive apt install -y zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent postgresql

RUN service postgresql start && \
  sudo -u postgres psql -c "CREATE USER zabbix WITH PASSWORD '$DB_PASSWORD';" && \
  sudo -u postgres createdb -O zabbix zabbix && \
  zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix && \
  sed -i "s/^#DBPassword=.*$/DBPassword=$DB_PASSWORD/" /etc/zabbix/zabbix_server.conf


EXPOSE 80

CMD service postgresql start && \
  service zabbix-server start && \
  service zabbix-agent start && \
  apache2ctl -D FOREGROUND