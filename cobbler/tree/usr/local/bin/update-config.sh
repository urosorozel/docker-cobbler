#!/bin/bash
echo "Updating configuration files from environment variables"
j2 --undefined /etc/cobbler/settings.j2 -o /etc/cobbler/settings
j2 --undefined /etc/cobbler/dhcp.template.j2 -o /etc/cobbler/dhcp.template
j2 --undefined /etc/apache2/conf-available/cobbler_web.conf.j2 -o /etc/apache2/conf-available/cobbler_web.conf
j2 --undefined /var/lib/cobbler/snippets/preseed_bionic_post_deploy.j2 -o /var/lib/cobbler/snippets/preseed_bionic_post_deploy
j2 --undefined /var/lib/cobbler/snippets/preseed_xenial_post_deploy.j2 -o /var/lib/cobbler/snippets/preseed_xenial_post_deploy
