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
sudo apt-get install git tmux
```

And then, start a new docker instance

```bash
docker run -it --privileged=true \
  --cap-add=SYS_ADMIN \
  -m 6144m -h bootcamp1.docker \
  --name bigbox -p 2222:22 -p 9530:9530 -p 8888:8888\
  -v /:/mnt/host \
  sunlab/bigbox:latest \
  /bin/bash
```

Please refer to [this section]({{ site.baseurl}}/env-local-docker#2-pull-and-run-docker-image) for some detail information.


{% msginfo %}
You may use [tmux](https://tmux.github.io/) to make your life better.
{% endmsginfo %}

