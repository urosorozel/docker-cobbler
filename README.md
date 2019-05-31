# docker-cobbler
## How to use
* Install Docker
* Download image
* Install dhcp-helper

### Configure dhcp-helper
If you are using ```docker run```

```
$ sudo vi /etc/default/dhcp-helper
DHCPHELPER_OPTS="-b docker0 -i ens3"
```

When usign docker-compose
```
$ sudo vi /etc/default/dhcp-helper
DHCPHELPER_OPTS="-i ens3 -s 172.16.238.10"
```
### Download ISO
* http://cdimage.ubuntu.com/releases/

### Bionic
http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.2-server-amd64.iso
### Xenial
http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso

### Download and mount loop
```
URL_BIONIC="http://cdimage.ubuntu.com/releases/18.04/release/ubuntu-18.04.2-server-amd64.iso"
FILENAME_BIONIC=$(basename $URL_BIONIC)
test -f ~/$FILENAME_BIONIC || curl $URL_BIONIC -o ~/$FILENAME_BIONIC
test -d /mnt/bionic || sudo mkdir /mnt/bionic
sudo mount -o loop ~/$FILENAME_BIONIC /mnt/bionic

URL_XENIAL="http://releases.ubuntu.com/16.04/ubuntu-16.04.6-server-amd64.iso"
FILENAME_XENIAL=$(basename $URL_XENIAL)
test -f ~/$FILENAME_XENIAL || curl $URL_XENIAL -o ~/$FILENAME_XENIAL
test -d /mnt/xenial ||sudo mkdir /mnt/xenial
sudo mount -o loop ~/$FILENAME_XENIAL /mnt/xenial
```

#### Run Cobbler image
```
docker run -dt  -v /mnt/:/mnt -p 80:80/tcp -p 69:69/udp  --name cobbler imagename
```


### Import Xenial and Bionic
Run script against container
```
docker exec -it cobbler /bin/bash -c "$(<import_iso.sh)"
```

```
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
```
