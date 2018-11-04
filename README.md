# jool-docker
[jool](https://www.jool.mx/en/index.html) as docker container.

### Install

Since jool needs a kernel module we need to prepare the host system. For this we need to meet following prerequisites on the host:
- curl
- docker
- dkms
- (GNU)tar
- cloned [repository](https://github.com/Jasper-Ben/jool-docker)

The installation itself is as simple as changing the variable JOOL_VERSION in the install.sh file to ones desire (for current versions see [here](https://www.jool.mx/en/download.html) and running `bash install.sh` as root. The script will install the kernel module and build the docker container.

### Uninstall

- remove Docker container
- run `dkms uninstall jool/<VERSION>` as root
