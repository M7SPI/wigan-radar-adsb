#!/bin/bash -eu
#####################################################################################
#                        FLY ITALY ADSB SETUP SCRIPT FORKED                         #
#####################################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                   #
# Copyright (c) 2022 Fly Italy Adsb                                                 #
#                                                                                   #
# Permission is hereby granted, free of charge, to any person obtaining a copy      #
# of this software and associated documentation files (the "Software"), to deal     #
# in the Software without restriction, including without limitation the rights      #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         #
# copies of the Software, and to permit persons to whom the Software is             #
# furnished to do so, subject to the following conditions:                          #
#                                                                                   #
# The above copyright notice and this permission notice shall be included in all    #
# copies or substantial portions of the Software.                                   #
#                                                                                   #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     #
# SOFTWARE.                                                                         #
#                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#####################################################################################
#                        ADS-B EXCHANGE SETUP SCRIPT FORKED                         #
#####################################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                   #
# Copyright (c) 2018 ADSBx                                    #
#                                                                                   #
# Permission is hereby granted, free of charge, to any person obtaining a copy      #
# of this software and associated documentation files (the "Software"), to deal     #
# in the Software without restriction, including without limitation the rights      #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         #
# copies of the Software, and to permit persons to whom the Software is             #
# furnished to do so, subject to the following conditions:                          #
#                                                                                   #
# The above copyright notice and this permission notice shall be included in all    #
# copies or substantial portions of the Software.                                   #
#                                                                                   #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     #
# SOFTWARE.                                                                         #
#                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

function abort() {
    echo ------------
    echo "Intallazione annullata (probabilmente premendo ESC)!"
    echo "Per favore esegui nuovamente questo script se non era tua intenzione"
    echo ------------
    exit 1
}

## CHECK IF SCRIPT WAS RAN USING SUDO

if [ "$(id -u)" != "0" ]; then
    echo -e "\033[33m"
    echo "Lo script deve essere eseguito tramite sudo o come utente root"
    echo -e "\033[37m"
    exit 1
fi

## CHECK FOR PACKAGES NEEDED BY THIS SCRIPT

echo "Verifico i pacchetti necessari per eseguire questo script.."

## ASSIGN VARIABLES

IPATH=/usr/local/share/flyitalyadsb
LOGDIRECTORY="$PWD/logs"

## WHIPTAIL DIALOGS

BACKTITLETEXT="Script di installazione del feed di Fly Italy Adsb"

whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button SI --no-button NO --yesno "Grazie per aver scelto di condividere i tuoi dati con Fly Italy Adsb.\n\nFly Italy Adsb è la prima community italiana che tratta di ADS-B. Questo script configurerà in automatico il tuo ricevitore per condividere i dati con Fly Italy Adsb\n\nVuoi continuare con l'installazione?" 13 78
if [[ $? != 0 ]]; then abort; fi

FLYITALYADSB_=$(whiptail --backtitle "$BACKTITLETEXT" --title "Nome utente" --nocancel --inputbox "\nPer favore inserisci un nome per il tuo ricevitore (http://flyitalyadsb.com/stato-mlat)\n\nUsa solo lettere e numeri.\nEsempio: \"Giorgio34\", \"Piacenza1\", etc." 12 78 3>&1 1>&2 2>&3)

if [[ $? != 0 ]]; then abort; fi

whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" \
    --msgbox "Affinché la multilaterazione funzioni inserisci con precisione la posizione dell'antenna\
    \n\nUn errore di 5 metri casuerà gravi problemi!\
    \n\nPer ottenere le coordinate puoi usare un sito web come mapcoordinates.net" 12 78

if [[ $? != 0 ]]; then abort; fi

#((-90 <= RECEIVERLATITUDE <= 90))
LAT_OK=0
until [ $LAT_OK -eq 1 ]; do
    RECEIVERLATITUDE=$(whiptail --backtitle "$BACKTITLETEXT" --title "Latitudine dell'antenna ${RECEIVERLATITUDE:-}" --nocancel --inputbox "\nInserisci la latitudine in gradi dell'antenna con almeno 5 decimali.\n(Esempio: 45.36373)" 12 78 3>&1 1>&2 2>&3)
    if [[ $? != 0 ]]; then abort; fi
    LAT_OK=`awk -v LAT="$RECEIVERLATITUDE" 'BEGIN {printf (LAT<90 && LAT>-90 ? "1" : "0")}'`
done


#((-180<= RECEIVERLONGITUDE <= 180))
LON_OK=0
until [ $LON_OK -eq 1 ]; do
    RECEIVERLONGITUDE=$(whiptail --backtitle "$BACKTITLETEXT" --title "Longitudine dell'antenna ${RECEIVERLONGITUDE:-}" --nocancel --inputbox "\nInserisci la longitudine in gradi dell'antenna con almeno 5 decimali.\n(Esempio: 9.78342)" 12 78 3>&1 1>&2 2>&3)
    if [[ $? != 0 ]]; then abort; fi
    LON_OK=`awk -v LAT="$RECEIVERLONGITUDE" 'BEGIN {printf (LAT<180 && LAT>-180 ? "1" : "0")}'`
done

ALT=""
until [[ $ALT =~ ^(.*)ft$ ]] || [[ $ALT =~ ^(.*)m$ ]]; do
    ALT=$(whiptail --backtitle "$BACKTITLETEXT" --title "Altitudine sul livello del mare dell'antenna:" \
        --nocancel --inputbox \
"\nInserisci la l'altitudine includendo l'unità:\n\n\
In piedi così:                   255ft\n\
o in metri così:               78m\n" \
        12 78 3>&1 1>&2 2>&3)
    if [[ $? != 0 ]]; then abort; fi
done

if [[ $ALT =~ ^-(.*)ft$ ]]; then
        NUM=${BASH_REMATCH[1]}
        NEW_ALT=`echo "$NUM" "3.28" | awk '{printf "-%0.2f", $1 / $2 }'`
        ALT=$NEW_ALT
fi
if [[ $ALT =~ ^-(.*)m$ ]]; then
        NEW_ALT="-${BASH_REMATCH[1]}"
        ALT=$NEW_ALT
fi

RECEIVERALTITUDE="$ALT"

#RECEIVERPORT=$(whiptail --backtitle "$BACKTITLETEXT" --title "Porta da dove lo script deve ascoltare" --nocancel --inputbox "\nCambia soltanto se sai quello che fai e hai cambiato manualmente la porta\nPer la maggior parte degli utenti va lasciato 30005." 10 78 "30005" 3>&1 1>&2 2>&3)


whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button SI --no-button NO --yesno "Ora sei pronto per condividere i tuoi dati con Fly Italy Adsb.\nProseguendo dichiari di aver letto e accettato le nostre condizioni di utilizzo accessibili a www.flyitalyadsb.com/informazioni-legali-e-privacy\n\nVuoi continuare?" 9 78
CONTINUESETUP=$?
if [ $CONTINUESETUP = 1 ]; then
    exit 0
fi

## BEGIN SETUP

{

    # Make a log directory if it does not already exist.
    if [ ! -d "$LOGDIRECTORY" ]; then
        mkdir $LOGDIRECTORY
    fi
    LOGFILE="$LOGDIRECTORY/image_setup-$(date +%F_%R)"
    touch $LOGFILE

    mkdir -p $IPATH >> $LOGFILE  2>&1
    cp uninstall.sh $IPATH >> $LOGFILE  2>&1

    if ! id -u flyitalyadsb &>/dev/null
    then
        adduser --system --home $IPATH --no-create-home --quiet flyitalyadsb >> $LOGFILE  2>&1
    fi

    echo 4
    sleep 0.25

    # BUILD AND CONFIGURE THE MLAT-CLIENT PACKAGE

    echo "Installando i prerequisiti" >> $LOGFILE
    echo "--------------------------------------" >> $LOGFILE
    echo "" >> $LOGFILE


    # Check that the prerequisite packages needed to build and install mlat-client are installed.

    # only install ntp if chrony and ntpsec aren't running
    if ! systemctl status chrony &>/dev/null && ! systemctl status ntpsec &>/dev/null; then
        required_packages="ntp "
    fi

    progress=4

    APT_UPDATED="false"

    if command -v apt &>/dev/null; then
        required_packages+="git curl build-essential python3-dev socat python3-venv libncurses5-dev netcat uuid-runtime zlib1g-dev zlib1g"
        for package in $required_packages; do
            if [ $(dpkg-query -W -f='${STATUS}' $package 2>/dev/null | grep -c "ok installed") -eq 0 ]; then

                [[ "$APT_UPDATED" == "false" ]] && apt update >> $LOGFILE 2>&1 && APT_UPDATED="true"
                [[ "$APT_UPDATED" == "false" ]] && apt update >> $LOGFILE 2>&1 && APT_UPDATED="true"
                [[ "$APT_UPDATED" == "false" ]] && apt update >> $LOGFILE 2>&1 && APT_UPDATED="true"

                echo Installing $package >> $LOGFILE  2>&1
                if ! apt install --no-install-recommends --no-install-suggests -y $package >> $LOGFILE  2>&1; then
                    # retry
                    apt clean >> $LOGFILE 2>&1
                    apt --fix-broken install -y >> $LOGFILE 2>&1
                    apt install --no-install-recommends --no-install-suggests -y $package >> $LOGFILE 2>&1
                fi
            fi
            progress=$((progress+2))
            echo $progress
        done
    elif command -v yum &>/dev/null; then
        required_packages+="git curl socat python3-virtualenv python3-devel gcc make ncurses-devel nc uuid zlib-devel zlib"
        yum install -y $required_packages >> $LOGFILE  2>&1
    fi

    hash -r

    bash create-uuid.sh >> $LOGFILE  2>&1

    echo "" >> $LOGFILE
    echo " BUILD AND INSTALL MLAT-CLIENT" >> $LOGFILE
    echo "-----------------------------------" >> $LOGFILE
    echo "" >> $LOGFILE

    CURRENT_DIR=$PWD

    MLAT_REPO="https://github.com/flyitalyadsb/mlat-client.git" 
    MLAT_VERSION="$(git ls-remote $MLAT_REPO 2>> $LOGFILE | grep HEAD | cut -f1)"
    if ! grep -e "$MLAT_VERSION" -qs $IPATH/mlat_version; then
        echo "Installando mlat-client in un virtual-env" >> $LOGFILE
        # Check if the mlat-client git repository already exists.
        VENV=$IPATH/venv
        mkdir -p $IPATH >> $LOGFILE 2>&1

        MLAT_DIR=/tmp/mlat-git
        # Download a copy of the mlat-client repository since the repository does not exist locally.
        rm -rf $MLAT_DIR
        git clone --depth 1 --single-branch $MLAT_REPO $MLAT_DIR >> $LOGFILE 2>&1
        cd $MLAT_DIR >> $LOGFILE 2>&1

        echo 34
        sleep 0.25


        rm "$VENV" -rf
        /usr/bin/python3 -m venv $VENV >> $LOGFILE 2>&1 && echo 36 \
            && source $VENV/bin/activate >> $LOGFILE 2>&1 && echo 38 \
            && python3 setup.py build >> $LOGFILE 2>&1 && echo 40 \
            && python3 setup.py install >> $LOGFILE 2>&1 \
            && git rev-parse HEAD > $IPATH/mlat_version 2>> $LOGFILE

    else
        echo "Mlat-client è già stato installato, git hash:" >> $LOGFILE
        cat $IPATH/mlat_version >> $LOGFILE
    fi

    echo 44

    cd $CURRENT_DIR

    sleep 0.25
    echo 54

    NOSPACENAME="$(echo -n -e "${FLYITALYADSB_}" | tr -c '[a-zA-Z0-9]_\- ' '_')"

    echo 64
    sleep 0.25

    # copy flyitalyadsb-mlat service file
    cp $PWD/scripts/flyitalyadsb-mlat.sh $IPATH >> $LOGFILE 2>&1
    cp $PWD/scripts/flyitalyadsb-mlat.service /lib/systemd/system >> $LOGFILE 2>&1

    # Enable flyitalyadsb-mlat service
    systemctl enable flyitalyadsb-mlat >> $LOGFILE 2>&1

    echo 70
    sleep 0.25

    # SETUP FEEDER TO SEND DUMP1090 DATA TO FLY ITALY ADSB

    echo "" >> $LOGFILE
    echo " COMPILANDO E INSTALLANDO IL FEED" >> $LOGFILE
    echo "-------------------------------------------------" >> $LOGFILE
    echo "" >> $LOGFILE

    #save working dir to come back to it
    SCRIPT_DIR=$PWD

    READSB_REPO="https://github.com/flyitalyadsb/readsb.git"
    READSB_VERSION="$(git ls-remote $READSB_REPO 2>> $LOGFILE | grep HEAD | cut -f1)"
    if ! grep -e "$READSB_VERSION" -qs $IPATH/readsb_version; then
        echo "Compilando e installando il client del feed" >> $LOGFILE
        echo "" >> $LOGFILE

        #compile readsb
        echo 72

        rm -rf /tmp/readsb &>/dev/null || true
        git clone --single-branch --depth 1 $READSB_REPO /tmp/readsb  >> $LOGFILE 2>&1
        cd /tmp/readsb
        echo 74
        if make -j3 AIRCRAFT_HASH_BITS=12 >> $LOGFILE 2>&1
        then
            git rev-parse HEAD > $IPATH/readsb_version 2>> $LOGFILE
        fi

        rm -f $IPATH/feed
        cp readsb $IPATH/feed >> $LOGFILE 2>&1

        cd /tmp
        rm -rf /tmp/readsb &>/dev/null || true
        echo "" >> $LOGFILE
        echo "" >> $LOGFILE
    else
        echo "Il client è già installato, git hash:" >> $LOGFILE 2>&1
        cat $IPATH/readsb_version >> $LOGFILE 2>&1
    fi

    # back to the working dir for install script
    cd $SCRIPT_DIR
    #end compile readsb

    echo "" >> $LOGFILE
    echo "" >> $LOGFILE

    cp $PWD/scripts/flyitalyadsb-feed.sh $IPATH >> $LOGFILE 2>&1
    cp $PWD/scripts/flyitalyadsb-feed.service /lib/systemd/system >> $LOGFILE 2>&1

    tee /etc/default/flyitalyadsb > /dev/null 2>> $LOGFILE <<EOF
    INPUT="127.0.0.1:30005"
    REDUCE_INTERVAL="0.5"
    # nome utente per controllare lo stato della MLAT-Multilaterazione (flyitalyadsb.com/stato-mlat)
    UTENTE="${NOSPACENAME}"
    LATITUDINE="$RECEIVERLATITUDE"
    LONGITUDINE="$RECEIVERLONGITUDE"
    ALTITUDINE="$RECEIVERALTITUDE"
    RISULTATI="--results beast,connect,localhost:30104"
    RISULTATI2="--results basestation,listen,31003"
    RISULTATI3="--results beast,listen,30157"
    RISULTATI4="--results beast,connect,localhost:30600"
    
    INPUT_TYPE="dump1090"
    MLATSERVER="dati.flyitalyadsb.com:30100"
    TARGET="--net-connector dati.flyitalyadsb.com,4905,beast_out,dati.flyitalyadsb.com,30102"
    NET_OPTIONS="--net-heartbeat 60 --net-ro-size 1280 --net-ro-interval 0.2 --net-ro-port 0 --net-sbs-port 0 --net-bi-port 30100 --net-bo-port 0 --net-ri-port 0"
EOF

    echo 82
    sleep 0.25

    # Enable flyitalyadsb-feed service
    systemctl enable flyitalyadsb-feed  >> $LOGFILE 2>&1

    echo 88
    sleep 0.25

    echo 94
    sleep 0.25

    # Start or restart flyitalyadsb-feed service
    systemctl restart flyitalyadsb-feed  >> $LOGFILE 2>&1

    echo 96

    # Start or restart flyitalyadsb-mlat service
    systemctl restart flyitalyadsb-mlat >> $LOGFILE 2>&1

    echo 100
    sleep 0.25

    MLAT_GIT_DIR="/usr/local/share/flyitalyadsb/mlat-client-git"

    UPDATER_SYSTEMD_SERVICE_PATH="/lib/systemd/system/flyitalyadsb-mlat-updater.service"
    read -r -d '' UPDATER_SYSTEMD_SERVICE <<-'EOF'
    [Unit]
    Description=Keep mlat-client up to date
    After=network.target

    [Service]
    Type=simple
    User=root
    WorkingDirectory=/usr/local/share/flyitalyadsb/mlat-client-git
    ExecStart=/usr/local/share/flyitalyadsb/mlat-client-git/scripts/update.sh

    [Install]
    WantedBy=timers.target

EOF

    ###

    UPDATER_SYSTEMD_TIMER_PATH="/lib/systemd/system/flyitalyadsb-mlat-updater.timer"
    read -r -d '' UPDATER_SYSTEMD_TIMER <<-'EOF'
    [Unit]
    Description=Keep mlat-client up to date

    [Timer]
    OnCalendar=daily
    Persistent=true

    [Install]
    WantedBy=timers.target

EOF


    if [ ! -d "$MLAT_GIT_DIR/.git" ]; then
        echo "Scarico il repository di mlat-client" >> $LOGFILE 2>&1
        mkdir -p "$MLAT_GIT_DIR"
        chown flyitalyadsb "$MLAT_GIT_DIR"
        sudo -u flyitalyadsb git clone "$MLAT_REPO" "$MLAT_GIT_DIR"  >> $LOGFILE 2>&1

        echo "Eseguo lo script di aggiornamento" >> $LOGFILE 2>&1
        cd "$MLAT_GIT_DIR" || exit 1
        ./scripts/update.sh >> $LOGFILE 2>&1
    fi

    echo "Installo il timer systemd per scaricare in automatico gli aggiornamenti" >> $LOGFILE 2>&1
    printf "%s" "$UPDATER_SYSTEMD_SERVICE" > "$UPDATER_SYSTEMD_SERVICE_PATH"
    chmod 644 "$UPDATER_SYSTEMD_SERVICE_PATH"
    printf "%s" "$UPDATER_SYSTEMD_TIMER" > "$UPDATER_SYSTEMD_TIMER_PATH"
    chmod 644 "$UPDATER_SYSTEMD_TIMER_PATH"

    echo "Avvio updater" >> $LOGFILE 2>&1
    systemctl enable flyitalyadsb-mlat-updater.timer >> $LOGFILE 2>&1
    systemctl start flyitalyadsb-mlat-updater.timer >> $LOGFILE 2>&1

    echo "Riavvio mlat-client" >> $LOGFILE 2>&1
    systemctl restart flyitalyadsb-mlat >> $LOGFILE 2>&1

    echo "Updater installato correttamente" >> $LOGFILE 2>&1

} | whiptail --backtitle "$BACKTITLETEXT" --title "Impostando il feed di Fly Italy Adsb"  --gauge "\nImpostando il feed di Fly Italy Adsb.\nPotrebbe impiegarci qualche minuto..." 8 60 0

whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button SI --no-button NO --yesno "Vuoi installare una mappa in cui sono visibili gli aerei che \nstai ricevendo in questo momento?\nSarà accessibile in locale a tuo_ip/flyitalyadsb" 9 70 0 
INTERFACCIA=$?
if [ $INTERFACCIA = 0 ]; then
{   
    set -e
    trap 'echo "------------"; echo "[ERROR] Error in line $LINENO when executing: $BASH_COMMAND"' ERR

    function getGIT() {
        # getGIT $REPO $BRANCH $TARGET-DIR
        if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
            echo "getGIT wrong usage, check your script or tell the author!" 1>&2
            return 1
        fi
        if ! cd "$3" &>/dev/null || ! git fetch origin "$2" >> $LOGFILE 2>&1|| ! git reset --hard FETCH_HEAD>> $LOGFILE 2>&1; then
            if ! rm -rf "$3" || ! git clone --depth 2 --single-branch --branch "$2" "$1" "$3" >> $LOGFILE 2>&1; then
                return 1
            fi
        fi
        return 0
    }
    REPO="https://github.com/wiedehopf/tar1090"
    BRANCH="master"
    GIT="/usr/local/share/tar1090/git"
    getGIT "$REPO" "$BRANCH" "$GIT" 
    bash "$GIT/install.sh" "/run/flyitalyadsb-feed" "flyitalyadsb"
}| whiptail --backtitle "$BACKTITLETEXT" --title "Impostando l'interfaccia di Fly Italy Adsb"  --gauge "\nImpostando l'interfaccia di Fly Italy Adsb.\nPotrebbe impiegarci qualche minuto..." 8 60 0
fi
whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button SI --no-button NO --yesno "Vuoi avere dei grafici statistici sul tuo ricevitore\n e una mappa con i dati che stai ricevendo accessibile ovunque?" 10 70  
STATS=$?
if [ $STATS = 0 ]; then
{
TMP=/tmp/graphs1090
if ! command -v git; then
    apt-get update
    apt-get install -y git
fi
rm -rf "$TMP"
set -e
git clone https://github.com/wiedehopf/graphs1090.git "$TMP"
echo "Installando Graphs1090"
cd "$TMP"
bash install.sh
TMP=/tmp/flyitalyadsb-stats-git
rm -rf "$TMP"
set -e
git clone https://github.com/flyitalyadsb/flyitalyadsb-stats.git "$TMP"
cd "$TMP"
echo "Installando il pacchetto di statistiche"
bash install.sh
} | whiptail --backtitle "$BACKTITLETEXT" --title "Impostando il pacchetto di statistiche di Fly Italy Adsb"  --gauge "\nImpostando il pacchetto di statistiche di Fly Italy Adsb.\nPotrebbe impiegarci qualche minuto..." 8 60 0
whiptail --backtitle "$BACKTITLETEXT" --title "$BACKTITLETEXT" --yes-button SI --no-button NO --yesno "Se lo desideri, lascia una email per essere contattato nel caso il tuo ricevitore dovesse andare offline per più di 3 giorni\ne per iscriverti alla nostra newsletter (Non più di una email al mese)." 10 70  
MAIL=$?
if [ $MAIL = 0 ]; then
    email=$(whiptail --backtitle "$BACKTITLETEXT" --title "Email"  --inputbox "\nInserisci la tua email" 8 60 3>&1 1>&2 2>&3)
    curl -d "mail=$email" https://flyitalyadsb.com/newsletter.php 
fi


## SETUP COMPLETE

ENDTEXT="
L'installazione è stata completata. Ora stai condividendo i tuoi dati con Fly Italy Adsb.
Puoi controllare lo stato del tuo ricevitore a questa pagina:
---------------------
https://www.flyitalyadsb.com/stato-mlat/${FLYITALYADSB_}
---------------------
Se hai incontrato qualche problema nell'installazione del feed o vorresti darci qualche suggerimento visita:
https://www.flyitalyadsb.com
oppure mandaci direttamente una email all'indirizzo:
mailto:installazione@flyitalyadsb.com
"


if ! nc -z 127.0.0.1 30005 && command -v nc &>/dev/null; then
    ENDTEXT2="
---------------------
Nessun dato disponibile sulla porta 30005!
---------------------
Se non hai installato nessun decoder visita questa pagina:
https://www.flyitalyadsb.com/come-costruire-un-ricevitore-ads-b/#installazione-dump1090-fa
Se invece il feed deve ricevere i dati da un altra porta/ip vai a questo link:
https://flyitalyadsb.com/configurazione-script
--------------------
"
    if [ -f /etc/fr24feed.ini ] || [ -f /etc/rb24.ini ]; then
        ENDTEXT2+="
Sembra che stai usando FR24 o BR24
Questo significa che devi abilitare la trasmissione dei dati sulla porta 30005! Per farlo:
- vai alla pagina: ip_del_tuo_raspberry:8754/settings.
- in \"process arguments\" aggiungi \" --net\" 
- imposta NO in RAW DATA, SBS FEED e DECODED DATA.
--Premi \"Save\" e poi \"restart\" 
Se non ti dovesse ancora funzionare, scrivici a mailto:installazione@flyitalyadsb.com
---------------------
"
    else
        ENDTEXT2+="
Se hai connesso a questo dispositivo una chiavetta SDR ma non hai 
ancora installato il decoder visita questa pagina:
https://www.flyitalyadsb.com/come-costruire-un-ricevitore-ads-b/#installazione-dump1090-fa
---------------------
"
    fi
    whiptail --title "Script di installazione del feed di Fly Italy Adsb" --msgbox "$ENDTEXT2" 27 73
    echo -e "$ENDTEXT2"
else
    # Display the thank you message box.
    whiptail --title "Script di installazione del feed di Fly Italy Adsb" --msgbox "$ENDTEXT" 27 73
    echo -e "$ENDTEXT"
fi

cp $LOGFILE $IPATH/lastlog &>/dev/null
exit 0

