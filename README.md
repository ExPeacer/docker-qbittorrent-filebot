# docker-qbittorrent-filebot
Qbittorrent with FileBot tool

For qBittorrent, I used [linuxserver/qbittorrent docker](https://hub.docker.com/r/linuxserver/qbittorrent).

For FileBot, please see https://www.filebot.net

## Usage example

### Bash

```sh
docker run -d --name=qbittorrent-filebot \
-e TZ=Europe/Budapest \
-e PUID=1000 -e PGID=1000 \
-e WEBUI_PORT=8080 \
-p 8080:8080 -p 6881:6881 -p 6881:6881/udp \
-v /mnt/media:/media \
-v /srv/qbittorrent-filebot/config:/config \
expeacer/qbittorrent-filebot
```

### docker-compose

```yaml
services:
  qbittorrent:
    container_name: qbittorrent-filebot
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Budapest
      - WEBUI_PORT=8080
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
    volumes:
      - /srv/qbittorrent-filebot/config:/config
      - /mnt/media:/media
      - type: tmpfs
        target: /tmp
    image: expeacer/qbittorrent-filebot
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 6881` | TCP connection port for qBt |
| `-p 6881/udp` | UDP connection port for qBt |
| `-p 8080` | HTTP GUI for qBt |
| `-e PUID=1000` | for UserID |
| `-e PGID=1000` | for GroupID |
| `-e TZ=Europe/Budapest` | Specify a timezone to use, ex. Europe/Budapest |
| `-e WEBUI_PORT=8080` | for changing the port of the webui |
| `-v /config` | Contains all relevant configuration files |
| `-v /media` | Contains your media files |

## Application Setup

The qBt's Web-based interface is at `<your-ip>:8080` and the default username/password is `admin/adminadmin`.

You can change username/password via the WebUI.

### WEBUI_PORT variable

Due to issues with CSRF and port mapping, should you require to alter the port for the webui you need to
change both sides of the `-p 8080` switch AND set the `WEBUI_PORT` variable to the new port.

For example, to set the port to 8090 you need to set `-p <external_port>:8090` and `-e WEBUI_PORT=8090`

If you have no webui , check the file /config/qBittorrent/qBittorrent.conf and edit or add the following lines:

```
WebUI\Address=*
WebUI\ServerDomains=*
```
