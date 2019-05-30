FROM ubuntu:bionic

ENV COBBLER_GIT_URL="https://github.com/cobbler/cobbler.git"
ENV COBBLER_GIT_TAG="v2.8.4"
ENV COBBLER_SECRET_KEY="!jd!o9tq7k+@-f-4+r#uqa9b9y(yo%2^ch2iq!pdgmo^$i360j"

ENV DEBIAN_FRONTEND noninteractive
#build-essential
RUN apt-get update && \
    apt-get install -y  fence-agents ipxe ipmitool \
             python \
             python2.7 \
             python-netaddr \
             python-yaml \
             python-simplejson \
             python-cheetah \
             python-urlgrabber \
             apache2 \
             libapache2-mod-wsgi \
             make \
             isc-dhcp-server \
             atftpd \
             git \
             lsb-release \
             net-tools \
             curl \
             supervisor \
             rsyslog \
             rsync && \
      curl https://bootstrap.pypa.io/get-pip.py | python && \
      pip install django==1.9.13 ipaddress j2cli


RUN git clone --branch $COBBLER_GIT_TAG $COBBLER_GIT_URL && cd cobbler && \
    make && \
    make install && \
    ln -s /srv/tftp /var/lib/tftpboot && \
    chown www-data /var/lib/cobbler/webui_sessions && \
    ln -s /usr/local/lib/python2.7/dist-packages/cobbler \
          /usr/lib/python2.7/dist-packages/cobbler && \
    echo "SECRET_KEY='$COBBLER_SECRET_KEY'" >> /usr/local/share/cobbler/web/settings.py && \
    sed -i "s|^INTERFACESv4=.*|INTERFACESv4='eth0'|g" /etc/default/isc-dhcp-server && \
    sed -i "s|^.*Order allow,deny.*||g" /etc/apache2/conf-available/cobbler.conf && \
    sed -i "s|^.*Allow from all.*|    Require all granted|g" /etc/apache2/conf-available/cobbler.conf && \
    sed -i "s|^.*server_args.*|        server_args             = -s /tftpboot|g" /etc/cobbler/tftpd.template && \
    echo "lanplus=1" >> /etc/cobbler/power/fence_ipmilan.template && \
    touch /var/lib/dhcp/dhcpd.leases && \
    cp /usr/lib/ipxe/undionly.kpxe /srv/tftp/undionly.kpxe && \
    a2enmod proxy proxy_http rewrite && \
    a2enconf cobbler cobbler_web
    
COPY tree/ /

RUN service apache2 start && \
    service cobblerd start && \
    cobbler signature update && \
    cobbler get-loaders && \
    cobbler sync

EXPOSE 80/tcp
EXPOSE 67/udp
EXPOSE 69/udp

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisor/conf.d/supervisord.conf"]
