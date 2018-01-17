---
layout: page
title: Docker in Local OS
categories: [section]
description: Georgia Tech big data bootcamp training material
---

{% objective %}

For the purpose of the environment normalization, we provide a simple [docker](https://docs.docker.com/) image for you, which contains most of the software required by this course. We also provide a few scripts to install some optional packages.

{% endobjective %}

The whole progress would seem as follow:

1. Make sure you have enough resource:
	1. It requires at least 8GB Physical RAM, 16GB or greater would be better
	2. It requires at least 15GB hard disk storage
2. Install a docker environment in local machine
3. Start Docker Service, pull images and create a instance
4. Just rock it!
5. Destroy the containers and images if they are not required anymore

# 0. System Environment

You should have enough system resource if you are planning to start a container in your local OS.
You are supposed to reserve at least 4 GB RAM for Docker, and some other memory for the host machine. While, you can still start all the Hadoop related services except [Zeppelin](https://zeppelin.apache.org), even if you only reserve 4GB for the virtual machine.


# 1. Install Docker

There is an official instruction [here](https://docs.docker.com/engine/installation/). You can check the official documentation to get the latest news and some detail explanations.

## Install Docker on RHEL/CentOS/Fedora

Please refer to [this page (CentOS)](https://docs.docker.com/engine/installation/linux/docker-ce/centos/) (or [this](https://docs.docker.com/engine/installation/linux/docker-ce/fedora/) for fedora) for the guide.

In brief, after updated your system, you can simply type the follow commands:

```bash
sudo yum install docker-ce -y # install docker package
sudo service  docker start # start docker service
chkconfig docker on # start up automatically
```

### FAQ

1. If your SELinux and BTRFS are on working, you may meet an error message as follow:

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

## Install Docker on Ubuntu/Debian

Please refer to [this link (for ubuntu)](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/) or [this one (debian)](https://docs.docker.com/engine/installation/linux/docker-ce/debian/) for the official instructions.

Generally, you are supposed to add the repository, and then

```bash
sudo apt-get install docker-ce
```


## Install Docker on macOS

macOS, Windows are kinds of different from Linux. They are using a third-party to host the backend VMs, using a 'docker-machine' to manage the virtual machines.

Currently, Docker is using VirtualBox as its backend.

If you are using macOS, you could follow [this guide](https://docs.docker.com/docker-for-mac/install/). Download an image, and drag to your 'Applications' folder, click and run.

However, here is an alternative solution.

First of all, you should make sure you have already installed [HomeBrew](http://brew.sh/).

Also, you are supposed to make sure your brew is up-to-date.

```bash
brew update # update brew repository
brew upgrade # update all packages for brew
brew doctor # check the status of your brew, it will provide some guide to make your brew be normal
```


Finally, you can install VirtualBox and Docker by using the following commands:

```bash
brew install Caskroom/cask/virtualbox
brew install docker-machine
brew install docker
```

To keep the Docker service active, we can use brew's service manager

```
$ brew services start docker-machine
==> Successfully started `docker-machine` (label: homebrew.mxcl.docker-machine)
```

Check the status:

```
$ brew services list
Name           Status  User Plist
docker-machine started name   /Users/name/Library/LaunchAgents/homebrew.mxcl.docker-machine.plist
```

Create a default instance using the following command:

```bash
docker-machine create --driver virtualbox --virtualbox-memory 8192  default
```

Please refer to [this link](https://docs.docker.com/machine/reference/create/) for some detail instruction.


Every time you created a new terminal window, and before you execute any command of 'docker *', you are supposed to run the following command:

```bash
eval $(docker-machine env default)
```

This command will append some environment variables to your current sessions.


### FAQ

1. Can not connect to docker:

```
$ docker ps -a
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

Please make sure you have already started your session.

2. Start docker-machine failed, can not get ip address

docker-machine is conflict with vpn [AnyConnect](https://faq.oit.gatech.edu/content/how-do-i-get-started-campus-vpn), if you are using it, just disconnect it.

3. If you meet an error similar to:

```
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
Error: Failure while executing: git config --local --replace-all homebrew.analyticsmessage true
```

try `xcode-select --install` and then `brew update`, `brew upgrade`, and `brew doctor` again


## Install Docker on Windows

An official guide for Docker for Windows could be found [here](https://docs.docker.com/docker-for-windows/install/)

Docker for Windows requires Windows 10 Pro or Enterprise version 1586/2016 RTM. 

<a>
![]({{ site.baseurl }}/image/docker/docker-for-windows-10-pre-reqyusute-not-fullfilled.png)
</a>

You may only able to install [Docker Toolbox on Windows](https://docs.docker.com/toolbox/toolbox_install_windows/) instead.

Going to the instruction page, click '[Get Docker Toolbox for Windows](https://download.docker.com/win/stable/DockerToolbox.exe)', you will download a installer. You are supposed to install Docker and VirtualBox during this wizard.

<a>
![]({{ site.baseurl }}/image/docker/terminal-and-virtualbox.png)
</a>

Click 'Docker Quickstart Terminal', you should able to start a bash session. Close it, click virtual box. You may find there is one virtual machine is in running. Close this machine, update the maximum base memory. 

<a>
![]({{ site.baseurl }}/image/docker/poweroff-vm.png)
</a>

<a>
![]({{ site.baseurl }}/image/docker/set-max-ram.png)
</a>

Click the 'Docker Quickstart Terminal' and your docker is ready.


# 2. Pull and run Docker image

## (1) Start the container with:

The basic start command should be:

```bash
docker run -it --privileged=true \
  --cap-add=SYS_ADMIN \
  -m 8192m -h bootcamp1.docker \
  --name bigbox -p 2222:22 -p 9530:9530 -p 8888:8888\
  sunlab/bigbox:latest \
  /bin/bash
```

In general, the synopsis of `docker run` is 

```bash
docker run [options] image[:tag|@digest] [command] [args]
```

If you are interested in the detail explanation of the args, please visit [this link](https://docs.docker.com/engine/reference/run/)

Specifically, we use:

```
-p host-port:vm-port
```

To forward the network stream from docker to host.

means you will visit `host-port` in your host environment and it will forward the message to `vm-port` in docker container. You can change this parameter `host-port` if you meet error like "port already in use".

`vm-port`s are reserved to:

```
8888 - Jupyter Notebook
9530 - Zeppelin Notebook
```

After started those services, you can access each Notebook with your local web browser.

+ If you are using Linux, you just need to visit "localhost:8888", or other port number if you changed `host-port`
+ If you are using macOS or Windows, you should get the Docker's IP first with command as follow:

```bash
$ printenv  | grep "DOCKER_HOST"
DOCKER_HOST=tcp://192.168.99.100:2376
```
Again, if you opened a new terminal session, you should run the following command first to check the IP from the command above. Otherwise, nothing will be shown.

```bash
$ eval $(docker-machine env default)
```
Then, you can visit 192.168.99.100:8888 or 192.168.99.100:9530 , or 192.168.99.100:`host-port` you changed.

## (2) Start all necessary services

```
/scripts/start-services.sh
```

If you wish to host Zeppelin, you should install it first by using the command:

```
/scripts/install-zeppelin.sh
```

and start the service by using command:

```
/scripts/start-zeppelin.sh
```

then, Zeppelin will listen the port `9530`


If you wish to host Jupyter, you can start it by using command:

```
/scripts/start-jupyter.sh
```

Jupyter will listen the port `8888`


## (3) Stop all services

You can stop services if you want:

```
/scripts/stop-services.sh
```


## (4) Detach or Exit

To detach instance for keeping it up,

```
ctrl + p, ctrl + q
```

To exit,

```
exit
```

## (5) Re-attach

If you detached a instance and want to attach again,
check the `CONTAINER ID` or `NAMES` of it.

```
$ docker ps -a
CONTAINER ID        IMAGE                  COMMAND                CREATED             STATUS              PORTS                                                                  NAMES
011547e95ef5        sunlab/bigbox:latest   "/tini -- /bin/bash"   6 hours ago         Up 4 seconds        0.0.0.0:8888->8888/tcp, 0.0.0.0:9530->9530/tcp, 0.0.0.0:2222->22/tcp   bigbox
```

Then attach it by:

```
$ docker attach <CONTAINER ID or NAMES>
```

## (5) Destroy instance

If you want to permanently remove container

```
$ docker rm <CONTAINER ID or NAMES>
```

## (6) Destroy images

If you want to permanently remove images

List images first

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
sunlab/bigbox       latest              4d3f9f826f10        16 hours ago        2.48GB
centos              7                   ff426288ea90        8 days ago          207MB
centos              latest              ff426288ea90        8 days ago          207MB
debian              stretch             da653cee0545        5 weeks ago         100MB
sunlab/bigdata      0.04                694cab7752ba        24 months ago       3.29GB
```

Remove them by REPOSITORY or IMAGE ID using command:

```
$ docker rmi <REPOSITORY or IMAGE ID>
```


