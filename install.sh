#!/bin/bash
TMP=/tmp/flyitalyadsb-git
if ! command -v git; then
    apt-get update
    apt-get install -y git
fi
rm -rf "$TMP"
set -e
git clone https://github.com/flyitalyadsb/fly-italy-adsb.git "$TMP"
cd "$TMP"
bash setup.sh
