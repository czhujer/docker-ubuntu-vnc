FROM docker.io/amd64/ubuntu:22.04

ENV VNC_PASSWORD=123_567
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe\Prague

RUN test -n "$http_proxy" && echo "Acquire::http::Proxy \"$http_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf
RUN test -n "$https_proxy" && echo "Acquire::https::Proxy \"$https_proxy\";" || exit 0 >> /etc/apt/apt.conf.d/10proxy.conf

# hadolint ignore=DL3015,DL3008
RUN  apt-get update && \
     apt-get install \
        -y \
        curl \
        vim \
        xfce4 xfce4-goodies tigervnc-standalone-server novnc && \
     rm -rf /var/lib/apt/lists/* && \
     rm -f /etc/apt/apt.conf.d/10proxy.conf

COPY vnc_config /root/.vnc/config
COPY entrypoint.sh /entrypoint.sh

RUN echo "$VNC_PASSWORD" > /root/plain_passwd.txt && \
    vncpasswd -f < /root/plain_passwd.txt > /root/.vnc/passwd && \
    rm -f /root/plain_passwd.txt && \
    chmod 600 /root/.vnc/passwd

# https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-entra-vpn-client-linux
# Install Microsoft's public key
RUN /bin/bash \
        -o pipefail \
        -c "curl -sSl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc"


# Install the production repo list for jammy
# For Ubuntu 22.04
# hadolint ignore=DL3059
RUN /bin/bash \
        -o pipefail \
        -c "curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list"

# hadolint ignore=DL3008
RUN  apt-get update && \
     apt-get install \
        -y \
        --no-install-recommends \
        python3-pip \
        python3-psutil \
        zenity \
        zenity-common \
        wget \
        software-properties-common \
        microsoft-azurevpnclient \
        && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# RUN pip3 \
#         install \
#         --no-cache-dir \
#         azure-cli==2.61.0

# fix terminal in xfce
RUN update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper

# firefox install
#
# hadolint ignore=DL4006,SC2028
RUN \
    add-apt-repository ppa:mozillateam/ppa && \
    echo "\n\
        Package: *\n\
        Pin: release o=LP-PPA-mozillateam\n\
        Pin-Priority: 1001\n\
        Package: firefox\n\
        Pin: version 1:1snap*\n\
        Pin-Priority: -1\n\
        " | tee /etc/apt/preferences.d/mozilla-firefox

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install \
    -y \
    --no-install-recommends \
    firefox \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /entrypoint.sh
# hadolint ignore=DL3025
ENTRYPOINT /entrypoint.sh
