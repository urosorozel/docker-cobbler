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
Below scrip will download Bionic and Xenial iso.
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

