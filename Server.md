## Docker Containers ##
```
Arcane - Docker Management
Immich - Photos
Jellyfin - Movies
NGINX Proxy Manager - Reverse Proxy
Sui - Homepage
UpSnap - Wake on LAN
```

## System Services ##
```
Samba
Homebridge
```

## Cockpit Reverse Proxy ##
Edit /etc/cockpit/cockpit.conf
```
[WebService]
Origins = https://cockpit.brdams.com wss://cockpit.brdams.com
ProtocolHeader = X-Forwarded-Proto
```
Set Cockpit in NGINX to https
