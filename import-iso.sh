PROFILE_NAME="ubuntu-18.04.2-server"
echo "Importing ${PROFILE_NAME}"
cobbler import --name="$PROFILE_NAME"  --path /mnt/bionic --arch=x86_64 --kickstart=/var/lib/cobbler/kickstarts/ubuntu-server-bionic-unattended-cobbler-rpc.seed --breed ubuntu
if [[ $? -eq 0 ]]; then
    for PROFILE in $(cobbler profile list | grep ${PROFILE_NAME});do
        echo "Updating profile $PROFILE"
        cobbler profile  edit \
          --name ${PROFILE}  \
          --kopts="ksdevice=bootif lang locale=en_US text netcfg/dhcp_timeout=60 netcfg/choose_interface=auto  tty0" \
    done
fi

PROFILE_NAME="ubuntu-16.04.6-server"
echo "Importing ${PROFILE_NAME}"
cobbler import --name="$PROFILE_NAME"  --path /mnt/xenial --arch=x86_64 --kickstart=/var/lib/cobbler/kickstarts/ubuntu-server-xenial-unattended-cobbler-rpc.seed --breed ubuntu
if [[ $? -eq 0 ]]; then
    for PROFILE in $(cobbler profile list | grep ${PROFILE_NAME});do
        echo "Updating profile $PROFILE"
        cobbler profile  edit \
          --name ${PROFILE}  \
          --kopts="ksdevice=bootif lang locale=en_US text netcfg/dhcp_timeout=60 netcfg/choose_interface=auto  tty0" \
    done
fi
echo "Running cobbler sync"
cobbler sync
