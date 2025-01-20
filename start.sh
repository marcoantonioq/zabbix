#!/bin/bash

[ -f ./zabbix/zabbix_server.conf ] || {
  touch ./zabbix/zabbix_server.conf
}
[ -f ./zabbix/zabbix_agentd.conf ] || {
  touch ./zabbix/zabbix_agentd.conf
}

[ -d ./zabbix/postgres_data ] || {
  mkdir -p ./zabbix/postgres_data
}

docker-compose up -d
