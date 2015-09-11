---
layout: page
title: CentOS VM in VirtualBox with Vagrant
description: Georgia Tech big data bootcamp training material
---

**Attention: only tested on Mac with admin previlege**

# Pre-requisite

In order to use the Docker environment we provide, you will need two pre-requisite
1. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Vagrant](http://www.vagrantup.com/downloads.html)

Also, please make sure you have enough free memory(4GB) available.

# Windows

*for windows user, install GIT bash for windows which include SSH for access to VM*

# Setup
With pre-requiste softwares properly installed, you could setup your Centos VM learning environment. Before you actually run commands, please make sure you have enough previlege. For example, virtual network adapter and network filesystem will be setup.

Open a terminal and you need to

1. Navigate to *vm* folder.
2. Run `.vagrant up` to provision and run the VM.

# Connect
You could connect to master node by run `vagrant ssh` in `vm` folder. You will find all materials in `/bootcamp` folder.


# Terminate
After you finish, you may want to terminate the virtual cluster. You could achieve that by

1. Navigate to *vm* folder.
2. Run `vagrant destroy -f` to destroy the VM.
