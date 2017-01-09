---
layout: page
title: Docker in Azure
description: Georgia Tech big data bootcamp training material
---
We can create a Docker on Ubuntu Server in Azure, and then pull image from hub.docker.com.

### Launch an Azure instance

1. Open the Portal in Azure at https://portal.azure.com
2. Click Virtual Machines on left sidebar.
3. Click “+ ADD” to create a new instance
4. Type “docker” in search box, and select ”Docker on Ubuntu Server”
5. Click “Create” on the introduction page
6. Fill your host name, user name, authentication.
7. Click Pricing Tier, and choise A2 or A3
8. Click “create” to create the instance

### Connect to the instance

1. Open the Portal in Azure at https://portal.azure.com
2. Click All resources on left sidebar.
3. Select your “Virtual machine (classic)” or “Cloud service”
4. find Public IP addresses in “Overview”
5. Login via command “ssh your-username@public-ip” in *nix or using putty for windows

### Start a docker container

Most of the related application are already installed, you can also install other apps with command “apt-get”.

For example:

```bash
sudo apt-get install git
```

and then execute

```bash
git clone https://bitbucket.org/realsunlab/bigdata-bootcamp.git
```

to clone related data.

You can start docker with command 

```bash
docker run -it --privileged=true -m 4096m -h bootcamp1.docker -v $HOME/bigdata-bootcamp:/home/ec2-user/bigdata-bootcamp sunlab/bigdata:0.04.1 /bin/bash
```

Please follow [this guide](https://hub.docker.com/r/sunlab/bigdata/) to start and stop services.

### Tip
You may use [tmux](https://tmux.github.io/) to make your life better.
