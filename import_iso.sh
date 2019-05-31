PROFILE_NAME="ubuntu-18.04.2-server"

cobbler import --name="$PROFILE_NAME"  --path /mnt/bionic --arch=x86_64 --kickstart=/var/lib/cobbler/kickstarts/ubuntu-server-bionic-unattended-cobbler-rpc.seed --breed ubuntu
if [[ $? -eq 0 ]]; then
    for PROFILE in $(cobbler profile list | grep ${PROFILE_NAME});do
        echo "Updating profile $PROFILE"
        cobbler profile  edit \
          --name ${PROFILE}  \
          --kopts="ksdevice=bootif lang console=ttyS0,115200n8 locale=en_US text priority=critical netcfg/dhcp_timeout=60 netcfg/choose_interface=auto  tty0" \
          --kopts-post="console=tty0 console=ttyS0,115200n8"
    done
fi

PROFILE_NAME="ubuntu-16.04.6-server"

cobbler import --name="$PROFILE_NAME"  --path /mnt/xenial --arch=x86_64 --kickstart=/var/lib/cobbler/kickstarts/ubuntu-server-xenial-unattended-cobbler-rpc.seed --breed ubuntu
if [[ $? -eq 0 ]]; then
    for PROFILE in $(cobbler profile list | grep ${PROFILE_NAME});do
        echo "Updating profile $PROFILE"
        cobbler profile  edit \
          --name ${PROFILE}  \
          --kopts="ksdevice=bootif lang console=ttyS0,115200n8 locale=en_US text priority=critical netcfg/dhcp_timeout=60 netcfg/choose_interface=auto  tty0" \
          --kopts-post="console=tty0 console=ttyS0,115200n8"
    done
fi
cobbler sync
