---
layout: page
title: UPR Big Data for Healthcare
description: Georgia Tech big data bootcamp training material
---

{% objective %}
Familiar with basic concepts and techniques in big data processing with Apache Spark.
{% endobjective %}

# Learning Environment Overview
To faciliate learning, we setup Docker environment for all participants. Below figure illustrate the setup
![docker-env]({{ site.baseurl }}/image/post/docker-environment.jpg "docker environment on AWS")
Basically, each user will have his/her own single node psudeo cluster on top of docker. Within one docker container, all tools like Hadoop, Spark are installed and configured. Several docker containers will share one AWS machine.

# Login onto AWS machine
Before access pseduo cluster, we need to log into AWS machine. Find your username and corresponding AWS machine ip below table.

|user name| AWS host IP|
|:--------|:-----------|
|user1 to user5||
|user6 to user10||
|user11 to user15||
|user16 to user20||
|user21 to user25||

### Linux and Mac

0. Download and save the [insecure\_private\_key](https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant) as `insecure_private_key` into current working directory.
1. Change permission of downloaded file `chmod 0600 insecure_private_key`.
2. Login into the AWS server with ssh as `ssh -i insecure_private_key <username>@<ip-address>`.

### Windows
0. Downlaod ans save the [insecure\_private\_key.ppk](https://gist.githubusercontent.com/anonymous/51a1d87c29357120b1ad/raw/95e7bd1450f37c0008a24561dd33f87dcde99420/insecure_private_key.ppk)
1. Download [putty](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe)
2. Double click to run putty.
3. Input user name and ip address in the format `<username>@<ip-address>` like ![environment-putty-1]({{ site.baseurl }}/image/post/environment-putty-1.jpeg "putty setp 1")
4. Select the downloaded *insecure\_private\_key.ppk* file as ![environment-putty-3]({{ site.baseurl }}/image/post/environment-putty-3.jpeg "putty setp 3")
6. **Optional** you can save the session by giving a name and click Save like ![environment-putty-2]({{ site.baseurl }}/image/post/environment-putty-2.jpeg "putty setp 2")
5. Click `Open` to connect.

# Connect to docker

2. Start virtual docker pseudo cluster by navigating into `~/vm` folder and type `vagrant up` then wait until finish.
3. Connect to docker using `vagrant ssh` in the `vm` folder.
4. Start hadoop and related services with `./start-all.sh`

You will find all sample code in `bigdata-bootcamp/sample/`.

{% comment %}
# Create HDFS home
When you first login, you may want to create home folder for your user name. You can achieve that by

1. switch to `hdfs` user, who is admin of HDFS, by `sudo su - hdfs`.
2. create a folder, i.e. `hdfs dfs -mkdir /user/hang`, remember to replace `hang` as your actual linux `<username>`.
3. change ownership of the new folder to yourself with `hdfs dfs -chown <username> /user/<username>`
4. type `exit` to resume your user rather than `hdfs` user.

{% endcomment %}

# Trouble shooting
**1. SSH permission denied from linux machine**

Please make sure you changed the access permission the private key to `0600` via `chmod 0600 insecure_private_key`.