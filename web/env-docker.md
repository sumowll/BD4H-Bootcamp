---
layout: page
title: Docker in Local OS
description: Georgia Tech big data bootcamp training material
---
If we want to start this environment, we should

+ prepare a docker environment in local machine
+ pull docker image sunlab/bigdata:0.04.1 or sunlab/bigdata:0.05

## 1. Install Docker

There is an official tutorial for docker here: [https://docs.docker.com/engine/installation/mac/](https://docs.docker.com/engine/installation/mac/)

Please note that if you currently have VirtualBox version 5.x.x installed, you will need to downgrade to version 4.3 on OS X. To do this uninstall VirtualBox with the uninstaller that came with it. If you receive an error stating that there are virtual boxes that are still running, go to the terminal and type in 

```
$ ps-ae | grep
```

to see which virtual boxes are still running. To kill all the running virtual boxes type in

```
$ killall -9 VBoxHeadless
```

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

For OS X you might need to type in the following to get into the ec2 in the next step: 

```
$ eval "$(docker-machine env default)"
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
### (1) Start the container with:
#### Ver 0.05 for Spark 2.0, etc. (Jupyter and Zeppelin will be added soon)

```
docker run -it --privileged=true -m 4096m -h bootcamp1.docker sunlab/bigdata:0.05 /bin/bash
```

##### or

#### Ver 0.04.1 for Spark 1.5 with Jupyter and Zeppelin

```
docker run -it --privileged=true -m 4096m -p 2222:22 -p 8888:8888 -p 8889:8889 -h bootcamp1.docker sunlab/bigdata:0.04.1 /bin/bash
```

If you receive an error here that states Cannot connect to the Docker daemon use

```
$eval "$(docker-machine env default)" 
``` 

Then retype the docker run -it above and it will expose three ports: 22, 8888, 8889 to host environment

```
-p host-port:vm-port
```

means you will visit `host-port` in your host environment and it will forward the message to `vm-port` in docker container. You can change this parameter `host-port` if you meet error like "port already in use".

Each `vm-port` is linked to:
```
8888 - Jupyter Notebook
8889 - Zeppelin Notebook
```

After you run Docker and start services as Step 2, you can access each Notebook with your web browser via:

##### In Linux (Ubuntu, CentOS, Fedora, ...)
You just need to visit "localhost:8888", or other port number if you changed `host-port`

##### In OS X
You should get the Docker's IP first with command as follow:

```
$ printenv  | grep "DOCKER_HOST"
DOCKER_HOST=tcp://192.168.99.100:2376
```

then, you can visit 192.168.99.100:8888 or 192.168.99.100:8889 , or 192.168.99.100:`host-port` you changed.

### (2) Start all necessary services
```
sudo service sshd start
sudo service zookeeper-server start
sudo service hadoop-yarn-proxyserver start
sudo service hadoop-hdfs-namenode start
sudo service hadoop-hdfs-datanode start
sudo service hadoop-yarn-resourcemanager start
sudo service hadoop-mapreduce-historyserver start
sudo service hadoop-yarn-nodemanager start
sudo service spark-worker start
sudo service spark-master start
sudo service hbase-regionserver start
sudo service hbase-master start
sudo service hbase-thrift start
```

If you have chosen 0.04.1 to use zeppelin, start one more service

```
sudo service zeppelin start
```

To use Jupyter Notebook:

```
jupyter notebook --ip=0.0.0.0
```

parameter `--ip=0.0.0.0` makes Jupyter allow you to visit this service via your web browser and it will open a web service listening port 8888.


### (3) Stop all services
You can stop services if you want:

```
sudo service zookeeper-server stop
sudo service hadoop-yarn-proxyserver stop
sudo service hadoop-hdfs-namenode stop
sudo service hadoop-hdfs-datanode stop
sudo service hadoop-yarn-resourcemanager stop
sudo service hadoop-mapreduce-historyserver stop
sudo service hadoop-yarn-nodemanager stop
sudo service spark-worker stop
sudo service spark-master stop
sudo service hbase-regionserver stop
sudo service hbase-master stop
sudo service hbase-thrift stop
```

and if you used Zeppelin,

```
sudo service zeppelin stop
```

### (4) Detach or Exit
To detach instance for keeping it up,
```
ctrl + p, ctrl + q
```
To exit,
```
exit
```

### (5) Re-attach
If you detached a instance and want to attach again,
check the `CONTAINER ID` or `NAMES` of it.
```
$ docker ps -a
CONTAINER ID        IMAGE                   COMMAND                CREATED             STATUS                      PORTS                                                    NAMES
c6b265ebd7d2        sunlab/bigdata:0.04.1   "/tini -- /bin/bash"   9 minutes ago       Up 4 seconds                0.0.0.0:8888-8889->8888-8889/tcp, 0.0.0.0:2222->22/tcp   berserk_hypatia
cd6b3e243157        sunlab/bigdata:0.04.1   "/tini -- /bin/bash"   23 minutes ago      Created                                                                              loving_hoover
92169a84b9a1        sunlab/bigdata:0.04.1   "/tini -- /bin/bash"   2 hours ago         Exited (0) 22 minutes ago                                                            peaceful_franklin
```

Then attach it by:

```
$ docker attach <CONTAINER ID or NAMES>
```

### (5) Destroy instance
If you want to permanently remove instance

```
$ docker rm <CONTAINER ID or NAMES>
```
