#!/bin/bash
set -x

IPATH=/usr/local/share/flyitalyadsb

systemctl disable --now flyitalyadsb-mlat
systemctl disable --now flyitalyadsb-feed

rm -f /lib/systemd/system/flyitalyadsb-mlat.service
rm -f /lib/systemd/system/flyitalyadsb-feed.service

rm -rf "$IPATH"

set +x

echo -----
echo "flyitalyadsb feed scripts have been uninstalled!"
