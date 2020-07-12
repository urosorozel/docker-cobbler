#!/bin/bash
echo "Updating configuration files from environment variables"
mkdir -p /data/var/lib
mkdir -p /data/etc/cobbler
mkdir -p /data/srv
mkdir -p /data/iso
j2 --undefined /etc/cobbler/settings.j2 -o /etc/cobbler/settings
j2 --undefined /etc/cobbler/dhcp.template.j2 -o /etc/cobbler/dhcp.template
j2 --undefined /var/lib/cobbler/snippets/preseed_bionic_post_deploy.j2 -o /var/lib/cobbler/snippets/preseed_bionic_post_deploy
j2 --undefined /var/lib/cobbler/snippets/preseed_xenial_post_deploy.j2 -o /var/lib/cobbler/snippets/preseed_xenial_post_deploy
if [[ -L /var/www ]]; then
    echo "is a symlink"; else
    cp --recursive --no-clobber -d /var/www /data/srv/
    rm -rf --verbose /var/www
    ln --symbolic --verbose /data/srv/www /var/www
fi
if [[ -L /etc/cobbler ]]; then
  echo "is a symlink"; else
  cp --recursive --no-clobber -d /etc/cobbler /data/etc/
  rm -rf --verbose /etc/cobbler
  ln --symbolic --verbose /data/etc/cobbler /etc/cobbler
fi
if [[ -L /var/lib/cobbler ]]; then
  echo "is a symlink"; else
  cp --recursive --no-clobber -d /var/lib/cobbler /data/var/lib/
  rm -rf --verbose /var/lib/cobbler/
  ln --symbolic --verbose /data/var/lib/cobbler /var/lib/cobbler
fi
if [[ -L /var/lib/dhcp ]]; then
    echo "is a symlink"; else
    cp --recursive --no-clobber -d /var/lib/dhcp /data/var/lib/
    rm -rf --verbose /var/lib/dhcp
    ln --symbolic --verbose /data/var/lib/dhcp /var/lib/dhcp
fi
chown -R 33:0 /data/var/lib/cobbler/webui_sessions
chown -R 33:0 /data/var/lib/cobbler/web.ss
if [[ -L /srv ]]; then
  echo "is a symlink"; else
  cp --recursive --no-clobber -d /srv /data/
  rm -rf --verbose /srv
  ln --symbolic --verbose /data/srv /srv
fi
unlink /var/lib/tftpboot/tftp
ln --symbolic --verbose /srv/tftpboot /var/lib/tftpboot/tftp
mkdir -p /data/srv/www/cobbler/links
sleep 30
pkill -f tftpd
supervisorctl start atftpd
