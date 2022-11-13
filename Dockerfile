FROM linuxserver/qbittorrent

ARG FILEBOT_VER=4.9.6

RUN	apk update \
	&& apk upgrade \
	&& apk add --no-progress --no-cache chromaprint openjdk11 openjdk11-jre zlib-dev libzen \
	libzen-dev libmediainfo libmediainfo-dev \
	&& mkdir -p /filebot \
	&& cd /filebot \
	&& wget "https://get.filebot.net/filebot/FileBot_${FILEBOT_VER}/FileBot_${FILEBOT_VER}-portable.tar.xz" -O /filebot/filebot.tar.xz \
	&& tar -xJf filebot.tar.xz \
	&& rm -rf filebot.tar.xz \
	# Fix filebot libs
	&& ln -sf /usr/lib/libzen.so /filebot/lib/Linux-x86_64/libzen.so \
	&& ln -sf /usr/lib/libmediainfo.so /filebot/lib/Linux-x86_64/libmediainfo.so \
	&& ln -sf /usr/local/lib/lib7-Zip-JBinding.so /filebot/lib/Linux-x86_64/lib7-Zip-JBinding.so \
	&& rm -rf /filebot/lib/FreeBSD-amd64 /filebot/lib/Linux-armv7l /filebot/lib/Linux-i686 /filebot/lib/Linux-aarch64

# Make Filebot binary runable from everywhere:
ENV PATH="/filebot:${PATH}"

# Env settings
ENV WEBUI_PORT 9090 \
	HOME /config  \
	XDG_CONFIG_HOME /config \
	XDG_DATA_HOME /config \
	FILEBOT_HOME /config/filebot

COPY root/ /
VOLUME /config
EXPOSE 6881 6881/udp 9090