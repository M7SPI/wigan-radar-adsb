#!/bin/bash
TMP=/tmp/wiganradaradsb-git
if ! command -v git; then
    apt-get update
    apt-get install -y git
fi
rm -rf "$TMP"
git clone https://github.com/M7SPI/wigan-radar-adsb.git "$TMP"
cd "$TMP" || exit 1;
BACKTITLETEXT="Wigan Radar Adsb"
if whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button ENGLISH --no-button ITALIANO --yesno "Wigan Radar Adsb. Welcome to Wigan Radar Adsb\n\nSeleziona la tua lingua. Select yor language. " 13 78;
then source $PWD/english/setup.sh
else source $PWD/italian/setup.sh
fi

