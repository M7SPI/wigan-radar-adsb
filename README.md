# ADS-B Exchange Setup Scripts :airplane:

These scripts aid in setting up your current ADS-B receiver to feed ADS-B Exchange.

### Obtaining And Using The Scripts

Use this command to start the setup process:

```
wget -O /tmp/axfeed.sh https://raw.githubusercontent.com/flyitalyadsb/flyitalyadsb/master/install.sh
sudo bash /tmp/axfeed.sh
```

### Checking status

### Display MLAT config
```
cat /etc/default/adsbexchange
```

### If you encounter issues, please supply these logs on the forum (last 20 lines for each is sufficient):

```
sudo journalctl -u adsbexchange-feed --no-pager
sudo journalctl -u adsbexchange-mlat --no-pager
```

### Restart

```
sudo systemctl restart adsbexchange-feed
sudo systemctl restart adsbexchange-mlat
```


### Systemd Status

```
sudo systemctl status adsbexchange-mlat
sudo systemctl status adsbexchange-feed
```


### Removal / disabling the services:

```
sudo bash /usr/local/share/adsbexchange/uninstall.sh
```

If the above doesn't work, you may be using an old version that didn't have the uninstall script, just disable the services and the scripts won't run anymore:

```
sudo systemctl disable --now adsbexchange-feed
sudo systemctl disable --now adsbexchange-mlat
```
