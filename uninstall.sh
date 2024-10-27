#!/bin/bash
set -x

IPATH=/usr/local/share/wiganradaradsb

systemctl disable --now wiganradaradsb-mlat
systemctl disable --now wiganradaradsb-feed

rm -f /lib/systemd/system/wiganradaradsb-mlat.service
rm -f /lib/systemd/system/wiganradaradsb-feed.service

rm -rf "$IPATH"

set +x

echo -----
echo "wiganradaradsb feed scripts have been uninstalled!"
