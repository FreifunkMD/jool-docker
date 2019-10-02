FROM debian:buster-slim

LABEL maintainer="Jasper Orschulko <jasper@fancydomain.eu>"

ARG JOOL_VER=4.0.5

RUN set -ex \
    && apt-get update \
    && apt-get install -y \
        wget \
        ca-certificates \
        gcc \
        build-essential \
        pkg-config \
        libnl-3-dev \
        # needed for autogen.sh
        autoconf \
        automake \
        bash \
        libtool \
        libxtables-dev \
        libnl-genl-3-dev \
        # needed to stop the build from failing on the kernel module (even though never used in container)
        linux-headers-amd64 \
    && wget https://github.com/NICMx/Jool/archive/v${JOOL_VER}.tar.gz -O /jool.tar.gz \
    && mkdir /jool \
    && tar -xvf /jool.tar.gz -C /jool --strip-components=1 \
    && cd /jool \
    && ./autogen.sh \
    && ./configure \
    && make -j$(nproc) \
    && make install \
    && apt-get remove --purge -y \
        wget \
        gcc \
        build-essential \
        pkg-config \
        libnl-3-dev \
        autoconf \
        automake \
        libtool \
        libxtables-dev \
        libnl-genl-3-dev \
        linux-headers-amd64 \
    && apt-get autoremove -y \
    && apt-get install -y \
        libnl-3-200 \
        libnl-genl-3-200 \
        libxtables12 \
    && rm -rf /var/lib/apt/lists \
    && mv /usr/local/bin/jool_siit /usr/bin/ \
    && mv /usr/local/bin/joold /usr/bin/ \
    && mkdir -p /usr/share/man/man8/ \
    && mv /usr/local/share/man/man8/jool_siit.8 /usr/share/man/man8/

COPY run.sh /root/run.sh
COPY netsocket.json /root/netsocket.json
