FROM ubuntu:bionic

ARG COBBLER_GIT_URL="https://github.com/cobbler/cobbler.git"
ARG COBBLER_GIT_TAG="v3.2.0"
ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -qqy gnupg curl && \
    /bin/sh -c "echo 'deb http://download.opensuse.org/repositories/Debian:/debbuild/Debian_10/ /' > /etc/apt/sources.list.d/debbuild.list" && \
    curl -sL http://download.opensuse.org/repositories/Debian:/debbuild/Debian_10/Release.key | apt-key add - && \
    apt-get update -qq && \
    apt-get install -qqy \
    debbuild \
    debbuild-macros \
    wget \
    pycodestyle \
    pyflakes3 \
    python-django-common \
    python3-coverage \
    python3-distro \
    python3-distutils \
    python3-django \
    python3-dnspython \
    python3-dns  \
    python3-dnsq  \
    python3-future \
    python3-ldap3 \
    python3-netaddr \
    python3-pip \
    python3-pycodestyle \
    python3-pytest \
    python3-setuptools \
    python3-simplejson  \
    python3-sphinx \
    python3-tornado \
    python3-tz \
    python3-yaml \
    python3-pip \
    liblocale-gettext-perl \
    lsb-release \
    xz-utils \
    bzip2 \
    dpkg-dev \
    tftpd-hpa \
    #createrepo \
    rsync \
    xorriso\
    fakeroot \
    patch \
    pax \
    git \
    hardlink \
    apache2 \
    libapache2-mod-wsgi-py3 \
    apache2-dev \
    libsasl2-dev \
    make \
    isc-dhcp-server \
    net-tools \
    supervisor \
    vim \
    rsyslog \
    grub-efi-amd64-signed \
  	fence-agents \
  	ipxe \
  	ipmitool \
	  lsof \
	  wget \
    systemd  && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

# commenting cloning a version until a post v3.1.2 release that includes PR #2387
#RUN git clone --branch $COBBLER_GIT_TAG $COBBLER_GIT_URL --depth 1 && cd cobbler && \
RUN git clone --depth 1 -n $COBBLER_GIT_URL && cd cobbler && \
    git checkout 6281d25cbe1d96b5e5b01d7a8c46f670643e9384 && \
    # Ubuntu 18.04's apt package python3-cheetah fails to install:
    pip3 install cheetah3 j2cli django-urls && \
    mkdir -p /etc/cobbler/power/ && \
    make && \
    make install && \
    ln -s /srv/tftp /var/lib/tftpboot && \
    ln -s /usr/local/share/cobbler /usr/share/ && \
    export COBBLER_SECRET_KEY=$(head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%()*+,-./:;<=>?@[\]^_`{|}~' | head -c 57 ; echo '') && \
    echo "SECRET_KEY='$COBBLER_SECRET_KEY'" >> /usr/local/share/cobbler/web/settings.py && \
    sed -i "s|^INTERFACESv4=.*|INTERFACESv4='eth0'|g" /etc/default/isc-dhcp-server && \
    echo "lanplus=1" >> /etc/cobbler/power/fence_ipmilan.template && \
    touch /var/lib/dhcp/dhcpd.leases && \
    a2enmod proxy proxy_http rewrite && \
    a2enconf cobbler cobbler_web

COPY tree/ /

RUN service apache2 start && \
    mkdir -p /srv/tftpboot && \
    touch /etc/genders && \
    /usr/local/bin/cobblerd  && \
    cobbler signature update && \
    cobbler get-loaders && \
    chown -R 33:0 /var/lib/cobbler/webui_sessions && \
    ln -s /var/www/cobbler_webui_content /var/www/html/

ENV COBBLER_SERVER_HOST=127.0.0.1 \
    COBBLER_NEXT_SERVER_HOST=192.168.10.91 \
    COBBLER_PUBLIC_SSH_KEY= \
    COBBLER_SUBNET=192.168.10.0 \
    COBBLER_NETMASK=255.255.255.0 \
    COBBLER_ROUTERS=192.168.10.1 \
    COBBLER_NAMESERVERS=1.1.1.1,8.8.8.8 \
    COBBLER_DHCP_RANGE="192.168.10.50 192.168.10.100" \
    COBBLER_DHCP_INTERFACE= \
    COBBLER_DHCP_INTERFACE2= \
    COBBLER_SUBNET2= \
    COBBLER_NETMASK2= \
    COBBLER_ROUTERS2= \
    COBBLER_NAMESERVERS2= \
    COBBLER_DHCP_RANGE2= \
    COBBLER_PROXY_URL_EXT= \
    COBBLER_PROXY_URL_INT=

EXPOSE 80/tcp
EXPOSE 67/udp
EXPOSE 69/udp

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf"]