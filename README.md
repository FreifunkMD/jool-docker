# jool-docker
[jool](https://www.jool.mx/en/index.html) as docker container.

### Install

Since jool needs a kernel module we need to prepare the host system. For this we need to meet following prerequisites on the host:
- curl
- docker
- dkms
- (GNU)tar
- cloned [repository](https://github.com/Jasper-Ben/jool-docker)

The installation itself is as simple as changing the variable JOOL_VERSION in the install.sh file to ones desire (for current versions see [here](https://www.jool.mx/en/download.html)) and running `bash install.sh` as root. The script will install the kernel module and pull the docker image. If pulling fails for the specified jool version, it will try to build it instead.

### Uninstall

- remove Docker container
- run `modprobe -r jool` as root
- run `dkms uninstall jool/<VERSION>` as root
- run `dkms remove jool/<VERSION> --all` as root
- check `dkms status jool` as root
