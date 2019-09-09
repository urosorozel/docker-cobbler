FROM ubuntu:bionic

ARG COBBLER_GIT_URL="https://github.com/cobbler/cobbler.git"
ARG COBBLER_GIT_TAG="v3.0.0"
ARG COBBLER_SECRET_KEY="!jd!o9tq7k+@-f-4+r#uqa9b9y(yo%2^ch2iq!pdgmo^$i360j"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y  fence-agents ipxe ipmitool \
             python3-pip \
             apache2 \
             apache2-dev \
             libsasl2-dev \
             libapache2-mod-wsgi-py3 \
             make \
             isc-dhcp-server \
             atftpd \
             git \
             lsb-release \
             net-tools \
             curl \
             supervisor \
             vim \
             rsyslog \
             grub-efi-amd64-signed \
             rsync && \
      ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
      ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
      pip3 install j2cli
      #curl https://bootstrap.pypa.io/get-pip.py | python && \
      #pip3 install django==1.9.13 ipaddress j2cli future distro coverage netaddr yaml simplejson cheetah urlgrabber


RUN git clone --branch $COBBLER_GIT_TAG $COBBLER_GIT_URL && cd cobbler && \
    pip3 install -r requirements.txt &&\
    make && \
    make install && \
    ln -s /srv/tftpboot /var/lib/tftpboot && \
    #chown www-data /var/lib/cobbler/webui_sessions && \
    echo "SECRET_KEY='$COBBLER_SECRET_KEY'" >> /usr/local/share/cobbler/web/settings.py && \
    sed -i "s|^INTERFACESv4=.*|INTERFACESv4='eth0'|g" /etc/default/isc-dhcp-server && \
    echo "lanplus=1" >> /etc/cobbler/power/fence_ipmilan.template && \
    touch /var/lib/dhcp/dhcpd.leases && \
    a2enmod proxy proxy_http rewrite && \
    a2enconf cobbler cobbler_web

COPY tree/ /

RUN service apache2 start && \
    #service cobblerd start && \
    mkdir /srv/tftpboot && \
    touch /etc/genders && \
    /usr/local/bin/cobblerd  && \
    cobbler signature update && \
    cobbler get-loaders && \
    cobbler sync && \
    cp /usr/lib/grub/x86_64-efi-signed/grubnetx64.efi.signed /srv/tftpboot/grubx64.efi && \
    cp /usr/lib/ipxe/undionly.kpxe /srv/tftpboot/undionly.kpxe

ENV COBBLER_SERVER_HOST=127.0.0.1 \
    COBBLER_NEXT_SERVER_HOST=192.168.10.91 \
    COBBLER_PUBLIC_SSH_KEY= \
    COBBLER_SUBNET=192.168.10.0 \
    COBBLER_NETMASK=255.255.255.0 \
    COBBLER_ROUTERS=192.168.10.1 \
    COBBLER_NAMESERVERS=1.1.1.1,8.8.8.8 \
    COBBLER_DHCP_RANGE="192.168.10.50 192.168.10.100" \
    COBBLER_PROXY_URL_EXT= \
    COBBLER_PROXY_URL_INT=

EXPOSE 80/tcp
EXPOSE 67/udp
EXPOSE 69/udp

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/supervisord.conf"]
