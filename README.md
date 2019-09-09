# docker-cobbler
Dockerfile will build an image with latest cobbler from source code, atftp server
isc dhcpd server and apache2 all managed by supervisord.

### Configure dhcp-helper
Cobbler container runs in unprivileged mode, to be able to deliver dhcp broadcast
to dhcp server in container we use dhcp-helper which will relay messages to either
network device or dhcp server ip.

* If you are using `docker run`
```
$ sudo vi /etc/default/dhcp-helper
DHCPHELPER_OPTS="-b docker0 -i ens3"
```

* when usign docker-compose
```
$ sudo vi /etc/default/dhcp-helper
DHCPHELPER_OPTS="-i ens3 -s 172.16.238.10"
```
* start dhcp-helper
```
$ sudo systemctl  start dhcp-helper.service
```

### Download Ubuntu ISO
* http://cdimage.ubuntu.com/releases/
* http://releases.ubuntu.com

### Download and mount loop
Below script will download Bionic and Xenial iso.
```
$ ./download-iso-and-mount.sh
```

### Docker run cobbler image
```
$ docker run -dt  -v /mnt/:/mnt -p 80:80/tcp -p 69:69/udp  --name cobbler urosorozel/cobbler:latest
```

### Docker-compose

```
$ docker-compose up --build -d
```

### Import Xenial and Bionic
Run script against container
```
docker exec -it cobbler /bin/bash -c "$(<import-iso.sh)"
```


# Test Docker Cobbler  in a VM

### Load tftp iptables modules

```
$ sudo modprobe ip_conntrack_tftp ip_nat_tftp
$ sudo iptables -t raw -A PREROUTING -p udp --dport 69 -j CT --helper tftp
```

### Install packages

```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce python-pip
```

### Update group membership for Docker and Libvirt

For Xenial

```
$ sudo usermod -aG docker,libvirtd ubuntu
```

or Bionic

```
$ sudo usermod -aG docker,libvirt ubuntu
```
logout and login to take an affect

```
$  sudo su - $USER
```

### Add libvirt network

* update subnet details if required
```
$ echo "<network><name>cobbler</name><forwardmode='nat'/><bridgename='cobbler'stp='on'delay='0'/><ipaddress='192.168.10.1'netmask='255.255.255.0'></ip></network>" | virsh net-define /dev/stdin 
```

* start cobbler libvirt network
```
$ sudo virsh start cobbler
```
### Update DHCP helper (DHCP relay)

* When testing in VM we want to relay all DHCP requests from cobbler bridge to container subnet
```
$ sudo vi /etc/default/dhcp-helper
DHCPHELPER_OPTS="-i cobbler -s 172.16.238.10"
```
* start dhcp-helper
```
$ sudo systemctl  restart dhcp-helper.service
```

### Install Docker-compose

```
$ sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
```

### Clone repository

```
$ git clone https://github.com/urosorozel/docker-cobbler.git
```

### Update docker-compose variables

* Update variable according to you environment

```
# Cobbler server IP/hostname
COBBLER_SERVER_HOST_IP=192.168.122.91
# TFTP server
COBBLER_NEXT_SERVER_HOST_IP=192.168.122.91

# SSH public key
COBBLER_PUBLIC_SSH_KEY=

# Dhcp settings
COBBLER_SUBNET=192.168.10.0
COBBLER_NETMASK=255.255.255.0
COBBLER_ROUTERS=192.168.10.1
COBBLER_NAMESERVERS=8.8.8.8,1.1.1.1
COBBLER_DHCP_RANGE=192.168.10.50 192.168.10.100

# Proxy
COBBLER_PROXY_URL_EXT=
COBBLER_PROXY_URL_INT=
```

### Run Cobbler

```
$ docker-compose up --build -d
```

### Download and mount loop
Below script will download Bionic and Xenial iso.

```
$ ./download-iso-and-mount.sh
```
### Import Xenial and Bionic

Run script against container
```
docker exec -it cobbler /bin/bash -c "$(<import-iso.sh)"
```

### Start qemu virtual machine

```
$ virt-install --connect qemu:///system \
               --name demo \
               --vcpu 2 \
               --memory 2048 \
               --disk size=10 \
               --pxe \
               --network network=cobbler,mac=0c:c4:7a:bb:ff:f1 \
               --virt-type qemu \
               --console pty,target_type=serial \
               --graphics vnc,listen=0.0.0.0 \
               --os-variant ubuntu18.04
```
