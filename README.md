# Fly Italy Adsb Script Installation

This script allows you to install the feed to share your data with Fly Italy Adsb.

### How to download and use the script?

Use these commands:

```
wget -O /tmp/flyitalyadsbfeed.sh https://raw.githubusercontent.com/flyitalyadsb/fly-italy-adsb/master/install.sh
sudo bash /tmp/flyitalyadsbfeed.sh
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
