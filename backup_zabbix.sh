#!/bin/sh
#Backup do baonco de dados e schema do Zabbix (ignorando maiores tabelas)
#
#
#
#Declaração de variáveis

DBNAME=zabbix
DBUSER=user_DB
DBPASS=senha_DB

BK_DEST=/tmp/BKP_ZBX

#Backup somente do ZabbixDB
sudo mysqldump --no-data --single-transaction -u$DBUSER -p"$DBPASS" "$DBNAME" | /bin/gzip > "$BK_DEST/$DBNAME-`date +%Y-%m-%d`-schema.sql.gz"

#Backup ignorando as maiores tabelas
sudo mysqldump -u"$DBUSER"  -p"$DBPASS" "$DBNAME" --single-transaction --skip-lock-tables --no-create-info --no-create-db \
    --ignore-table="$DBNAME.acknowledges" \
    --ignore-table="$DBNAME.alerts" \
    --ignore-table="$DBNAME.auditlog" \
    --ignore-table="$DBNAME.auditlog_details" \
    --ignore-table="$DBNAME.escalations" \
    --ignore-table="$DBNAME.events" \
    --ignore-table="$DBNAME.history" \
    --ignore-table="$DBNAME.history_log" \
    --ignore-table="$DBNAME.history_str" \
    --ignore-table="$DBNAME.history_str_sync" \
    --ignore-table="$DBNAME.history_sync" \
    --ignore-table="$DBNAME.history_text" \
    --ignore-table="$DBNAME.history_uint" \
    --ignore-table="$DBNAME.history_uint_sync" \
    --ignore-table="$DBNAME.dhosts" \
    --ignore-table="$DBNAME.dservices" \
    --ignore-table="$DBNAME.proxy_history" \
    --ignore-table="$DBNAME.proxy_dhistory" \
    --ignore-table="$DBNAME.trends" \
    --ignore-table="$DBNAME.trends_uint" \
    | /bin/gzip > "$BK_DEST/$DBNAME-`date +%Y-%m-%d`-config.sql.gz"