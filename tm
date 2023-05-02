syst_d


systemctl stop [servicename]
systemctl disable [servicename]
rm /etc/systemd/system/[servicename]
rm /etc/systemd/system/[servicename] # and symlinks that might be related
rm /usr/lib/systemd/system/[servicename] 
rm /usr/lib/systemd/system/[servicename] # and symlinks that might be related
systemctl daemon-reload
systemctl reset-failed


add unit     /etc/systemd/system/dms.service  



[Unit]
Description=DMS UPnP Media Server
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=seb
ExecStart=/usr/bin/dms -friendlyName DNAP  -path /home/seb/video/dlna

[Install]
WantedBy=default.target

                                                                                       
