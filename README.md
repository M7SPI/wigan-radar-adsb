# Wigan Radar Adsb Script Installer

This script allows you to install the feed to share your data with Wigan Radar.

### How to download and use the script?

Use these commands:

```
wget -O /tmp/wiganradaradsbfeed.sh https://github.com/M7SPI/wigan-radar-adsb/blob/master/install.sh
sudo bash /tmp/wiganradaradsbfeed.sh
```

### To check the status:

### Show configuration 

```
cat /etc/default/flyitalyadsb
```

### If you encounter any issues, contact us (www.flyitalyadsb.com/contattaci) and send us the report of these commands (the last twenty lines are sufficient)

```
sudo journalctl -u flyitalyadsb-feed --no-pager
sudo journalctl -u flyitalyadsb-mlat --no-pager
```

### To restart the script:

```
sudo systemctl restart flyitalyadsb-feed
sudo systemctl restart flyitalyadsb-mlat
```

### Systemd Status

```
sudo systemctl status flyitalyadsb-mlat
sudo systemctl status flyitalyadsb-feed
```

### To remove/disable the script:

```
sudo bash /usr/local/share/flyitalyadsb/uninstall.sh
```
