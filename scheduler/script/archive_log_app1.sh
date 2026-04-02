#!/bin/sh

LOGCLI_BIN="/usr/bin/logcli"
DATE_STR=$(date +%Y%m%d_%H%M)
LOKI_ADDR=${LOKI_ADDR}
DIR="/archive/app"

mkdir -p $DIR
chown 1000:1000 -R $DIR

FILE_NAME="$DIR/log_app1_${DATE_STR}.txt"

$LOGCLI_BIN query \
    '{container_name="app1"}' \
    --addr="http://host.docker.internal:3100" \
    --since 24h \
    --limit=100000 > "$FILE_NAME"

gzip -f "$FILE_NAME"
chown 1000:1000 "${FILE_NAME}.gz"

cd $DIR
ls -t log_app1_*.gz | tail -n +4 | xargs -r rm