---
layout: page
title: Docker in CoreOS VM
description: Georgia Tech big data bootcampt training material
---

**Attention: only tested on Mac with admin previlege**

# Pre-requisite

In order to use the Docker environment we provide, you will need two pre-requisite
1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](http://www.vagrantup.com/downloads.html)

Also, please make sure you have enough free memory(*TODO: HOW MUCH*) available.

# Setup
With pre-requiste softwares properly installed, you could setup your CoreOS + Docker learning environment. Before you actually run commands, please make sure you have enough previlege to change system network setting. For example, virtual network adapter and network filesystem will be setup.

Open a terminal and you need to

1. Navigate to *docker* folder.
2. Run `./cluster.sh --build-image` to build docker image and setup the CoreOS VM.
3. Create a cluster of 3 nodes with `./cluster.sh --provision`


# Connect
You could connect to master node by run `vagrant ssh node1` in `docker` folder.You will find all materials in `/bootcamp` folder.


# Terminate
After you finish, you may want to terminate the virtual cluster. You could achieve that by

1. Navigate to *docker* folder.
2. Run `./cluster.sh --destroy` to remove docker cluster
3. Navigate to *coreos* subfolder.
4. Run `vagrant suspend` to suspend CoreOS or `vagrant destroy` to remove everything.


