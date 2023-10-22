#!/bin/bash

source /etc/default/flyitalyadsb

INPUT_IP=$(echo $INPUT | cut -d: -f1)
INPUT_PORT=$(echo $INPUT | cut -d: -f2)
SOURCE="--net-connector $INPUT_IP,$INPUT_PORT,beast_in"

sleep 2

while ! nc -z "$INPUT_IP" "$INPUT_PORT" && command -v nc &>/dev/null; do
    echo "<3>Non riesco a connetermi a $INPUT_IP:$INPUT_PORT, riprovo tra 30 secondi."
    sleep 30
done

/usr/local/share/flyitalyadsb/feed --net --net-only --debug=n --quiet \
    --write-json /run/flyitalyadsb-feed \
    --net-beast-reduce-interval $REDUCE_INTERVAL \
    $TARGET $NET_OPTIONS $SOURCE \
    --lat "$LATITUDINE" --lon "$LONGITUDINE" \
    --db-file none \
    --uuid-file /usr/local/share/flyitalyadsb/flyitalyadsb-uuid
