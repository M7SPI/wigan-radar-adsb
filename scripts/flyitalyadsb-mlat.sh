#!/bin/bash

source /etc/default/flyitalyadsb

INPUT_IP=$(echo $INPUT | cut -d: -f1)
INPUT_PORT=$(echo $INPUT | cut -d: -f2)

while ! nc -z "$INPUT_IP" "$INPUT_PORT" && command -v nc &>/dev/null; do
    echo "<3>Non riesco a connettermi a $INPUT_IP:$INPUT_PORT, riprovo fra 30 secondi."
    sleep 30
done

/usr/local/share/flyitalyadsb/venv/bin/mlat-client \
    --input-type "$INPUT_TYPE" --no-udp \
    --input-connect "$INPUT" \
    --server "$MLATSERVER" \
    --user "$UTENTE" \
    --lat "$LATITUDINE" \
    --lon "$LONGITUDINE" \
    --alt "$ALTITUDINE" \
    $PRIVACY \
    $RESULTS $RESULTS1 $RESULTS2 $RESULTS3 $RESULTS4
