if [ ! -f "/usr/local/bin/cobbler" ]; then
  echo "This script should only be run in container, execute:"
  echo "\$ docker exec -it cobbler /bin/bash -c \"\$(<import-iso.sh)\""
  exit 1
fi
DISTRO_NAME="ubuntu-18.04.4-server"
TEMPLATE="ubuntu-server-bionic-unattended-cobbler-rpc.seed"
echo "Importing ${DISTRO_NAME}"
cobbler import --name="$DISTRO_NAME"  --path /data/iso/${DISTRO_NAME} --arch=x86_64 --breed ubuntu --autoinstall ${TEMPLATE}
if [[ $? -eq 0 ]]; then
    for distro in $(cobbler distro list | grep ${DISTRO_NAME});do
        echo "Updating distro $distro"
        cobbler distro edit \
          --name ${distro}  \
          --kernel-options="ksdevice=bootif lang priority=critical locale=en_US text netcfg/dhcp_timeout=60 netcfg/choose_interface=auto console=tty0"
    done
fi
