#!/bin/bash

source /etc/default/flyitalyadsb

INPUT_IP=$(echo $INPUT | cut -d: -f1)
INPUT_PORT=$(echo $INPUT | cut -d: -f2)
SOURCE="--net-connector $INPUT_IP,$INPUT_PORT,beast_in"

sleep 2

while ! nc -z "$INPUT_IP" "$INPUT_PORT" && command -v nc &>/dev/null; do
    echo "<3>Could not connect to $INPUT_IP:$INPUT_PORT, retry in 30 seconds."
    sleep 30
done

/usr/local/share/flyitalyadsb/feed --net --net-only --debug=n --quiet \
    --write-json /run/flyitalyadsb-feed \
    --net-beast-reduce-interval $REDUCE_INTERVAL \
    $TARGET $NET_OPTIONS $SOURCE \
    --lat "$LATITUDE" --lon "$LONGITUDE" \
    --db-file none
