FROM linuxserver/qbittorrent:latest

RUN	apk update \
	&& apk upgrade \
	&& apk add --no-progress --no-cache chromaprint openjdk11 openjdk11-jre zlib-dev libzen \
	libzen-dev libmediainfo libmediainfo-dev \
	&& mkdir -p /filebot \
	&& cd /filebot \
	&& FILEBOT_VER="$(curl -s https://get.filebot.net/filebot/ | grep -o "FileBot_[0-9].[0-9].[0-9]" | sort | tail -n1)" \
	&& wget -q "https://get.filebot.net/filebot/${FILEBOT_VER}/${FILEBOT_VER}-portable.tar.xz" -O /filebot/filebot.tar.xz \
	&& tar -xJf filebot.tar.xz \
	&& rm -rf filebot.tar.xz \
	# Fix filebot libs
	&& ln -sf /usr/lib/libzen.so /filebot/lib/Linux-x86_64/libzen.so \
	&& ln -sf /usr/lib/libmediainfo.so /filebot/lib/Linux-x86_64/libmediainfo.so \
	&& ln -sf /usr/local/lib/lib7-Zip-JBinding.so /filebot/lib/Linux-x86_64/lib7-Zip-JBinding.so \
	&& rm -rf /filebot/lib/FreeBSD-amd64 /filebot/lib/Linux-armv7l /filebot/lib/Linux-i686 /filebot/lib/Linux-aarch64

# Env settings
ENV	WEBUI_PORT=9090 \
	HOME=/config \
	XDG_CONFIG_HOME=/config \
	XDG_DATA_HOME=/config \
	PATH=/filebot:${PATH}

COPY	root/ /
VOLUME	/config
EXPOSE	6881 6881/udp 9090