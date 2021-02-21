# jool-docker
[jool](https://www.jool.mx/en/index.html) as docker container.


### Dependencies

Since jool needs a kernel module we need to prepare the host system. For this we need to meet following prerequisites on the host:
- curl
- docker
- dkms
- (GNU)tar
- cloned [repository](https://github.com/Jasper-Ben/jool-docker)
### Setup
```bash
git clone ttps://github.com/FreifunkMD/jool-docker /opt/jool-docker
/opt/jool-docker
vi install.sh
./install.sh
```
The installation itself is as simple as changing the variable JOOL_VERSION in the install.sh file to ones desire (for current versions see [here](https://www.jool.mx/en/download.html)) and running `bash install.sh` as root. The script will install the kernel module and pull the docker image. If pulling fails for the specified jool version, it will try to build it instead.

### Uninstall

```bash
docker stop jool-ffmd
docker rm jool-ffmd
docker image rm jool-ffmd
```

Run as root
```bash
modprobe -r jool
dkms uninstall jool/<VERSION>
dkms remove jool/<VERSION> --all
dkms status jool
```
- remove Docker container
- run `` as root
- run `` as root
- run `` as root
- check `` as root
