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
BACKTITLETEXT="Fly Italy Adsb"
if whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button ENGLISH --no-button ITALIANO --yesno "Benvenuto su Fly Italy Adsb. Welcome to Fly Italy Adsb\n\nSeleziona la tua lingua. Select yor language. " 13 78;
then $PWD/english/setup.sh
else $PWD/italian/setup.sh
fi

