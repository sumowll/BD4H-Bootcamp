---
layout: page
title: Docker in Local OS
description: Georgia Tech big data bootcamp training material
---
If we want to start this environment, we should

+ prepare a docker environment in local machine
+ pull docker image sunlab/bigdata:0.05

## 1. Install Docker

There is an official tutorial for docker here: [https://docs.docker.com/engine/installation/mac/](https://docs.docker.com/engine/installation/mac/)

### Mac OSX
OSX users can also install Docker via [HomeBrew](http://brew.sh/)

```
$ brew install Caskroom/cask/virtualbox
$ brew install docker-machine
$ brew install docker
```

To keep the Docker service active, we can use brew's service manager

```
$ brew services start docker-machine
==> Successfully started `docker-machine` (label: homebrew.mxcl.docker-machine)
```

check the status:

```
$ brew services list
Name           Status  User Plist
docker-machine started name   /Users/name/Library/LaunchAgents/homebrew.mxcl.docker-machine.plist
```

We can create a default instance as this link:  https://docs.docker.com/machine/reference/create/

```
$ docker-machine create --driver virtualbox --virtualbox-memory 4096  default
```
__At least 4GB memory for vm is required.__

Execute the following command before using other docker commands.

```
$ eval $(docker-machine env default)
```


### CentOS 7

Just simply install

```
$ sudo yum install docker
$ sudo service  docker start
$ chkconfig docker on
```

#### Some Common issues :

1. When using SELinux + BTRFS, you may meet an error message as follow:

```
# systemctl status docker.service -l
...
SELinux is not supported with the BTRFS graph driver!
...
```

Modify /etc/sysconfig/docker as follow:

```
# Modify these options if you want to change the way the docker daemon runs
#OPTIONS='--selinux-enabled'
OPTIONS=''
...
```

Restart your docker service

2. Storage Issue:
Error message found in /var/log/upstart/docker.log

```
[graphdriver] using prior storage driver \"btrfs\"...
```

Just delete directory /var/lib/docker and restart docker service

### Ubuntu
NOT TESTED
Please refer to:
[https://docs.docker.com/engine/installation/linux/ubuntulinux/](https://docs.docker.com/engine/installation/linux/ubuntulinux/)


### Windows
NOT TESTED
Please refer to:
[https://docs.docker.com/engine/installation/windows/](https://docs.docker.com/engine/installation/windows/)


## 2. Pull and run Docker image
Please refer to:
[https://hub.docker.com/r/sunlab/bigdata/](https://hub.docker.com/r/sunlab/bigdata/)
