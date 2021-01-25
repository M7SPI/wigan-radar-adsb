# Installazione dello script di Fly Italy Adsb 

Questo script ti permette di installare il feed per condividere i tuoi dati con Fly Italy Adsb

### Come scaricare e utilizzare lo script?

Usa questi comandi:

```
wget -O /tmp/flyitalyadsbfeed.sh https://raw.githubusercontent.com/flyitalyadsb/flyitalyadsb/master/install.sh
sudo bash /tmp/flyitalyadsbfeed.sh
```

### Per controllare lo stato:

### Mostra la configurazione MLAT
```
cat /etc/default/flyitalyadsb
```

### Se incontri problemi, contattaci (www.flyitalyadsb.com/contattaci) e inviaci il report di questo comandi (le ultime venti righe sono sufficienti)

```
sudo journalctl -u adsbexchange-feed --no-pager
sudo journalctl -u adsbexchange-mlat --no-pager
```

### Per riavviare il programma:

```
sudo systemctl restart flyitalyadsb-feed
sudo systemctl restart flyitalyadsb-mlat
```


### Stato del Systemd

```
sudo systemctl status flyitalyadsb-mlat
sudo systemctl status flyitalyadsb-feed
```


### Per rimuovere/disabilitare lo script:

```
sudo bash /usr/local/share/flyitalyadsb/uninstall.sh
```
