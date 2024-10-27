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
cat /etc/default/wiganradaradsb
```

### If you encounter any issues, contact us (www.wiganradar.co.uk) and send us the report of these commands (the last twenty lines are sufficient)

```
sudo journalctl -u wiganradaradsb-feed --no-pager
sudo journalctl -u wiganradaradsb-mlat --no-pager
```

### To restart the script:

```
sudo systemctl restart wiganradaradsb-feed
sudo systemctl restart wiganradaradsb-mlat
```

### Systemd Status

```
sudo systemctl status wiganradaradsb-mlat
sudo systemctl status wiganradaradsb-feed
```

### To remove/disable the script:

```
sudo bash /usr/local/share/wiganradaradsb/uninstall.sh
```
