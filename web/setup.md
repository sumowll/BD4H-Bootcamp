---
layout: page
title: GT Big Data Training
description: Georgia Tech big data bootcamp training material
---

{% objective %}
Familiarize audience with basic concepts and techniques in big data processing.
{% endobjective %}
# [Agenda](https://drive.google.com/file/d/0B0U9INmaW-DuV0dBTmVzUTBYMHc/view?usp=sharing)

# Learning Environment Overview
To faciliate learning, we setup Docker environment for all participants. Below figure illustrate the setup
![docker-env]({{ site.baseurl }}/image/post/docker-environment.jpg "docker environment on AWS")
Basically, each user will have his/her own single node psudeo cluster on top of docker. Within one docker container, all tools like Hadoop, Spark are installed and configured. Several docker containers will share one AWS machine.

Below table list username and corresponding AWS host IP. Find your username and corresponding AWS machine ip below table. Please remember your user name as we will use that in several places later.


|user name| AWS host IP|
|:--------|:-----------|
| user1 to user5 |54.175.188.163|
| user6 to user10 |54.85.218.129|
| user11 to user15 |54.172.119.247|
| user16 to user20 |52.90.175.84|
| user21 to user25 |52.90.33.136|
| user26 to user30 |54.86.150.45|
| user31 to user35 |52.90.175.102|
| user36 to user40 |54.164.249.9|

# Login onto AWS machine
Before access pseduo cluster, we need to log into AWS machine. 

## Windows user
0. Downlaod ans save the [insecure\_private\_key.ppk](https://gist.githubusercontent.com/anonymous/51a1d87c29357120b1ad/raw/95e7bd1450f37c0008a24561dd33f87dcde99420/insecure_private_key.ppk)
1. Download [putty](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe)
2. Double click to run putty.
3. Input user name and ip address in the format `<username>@<ip-address>` like 
![environment-putty-1]({{ site.baseurl }}/image/post/environment-putty-1.jpeg "putty setp 1")
4. Select the downloaded *insecure\_private\_key.ppk* file as ![environment-putty-2]({{ site.baseurl }}/image/post/environment-putty-2.jpeg "putty setp 2")
6. **Optional** you can save the session by giving a name and click Save like 
![environment-putty-3]({{ site.baseurl }}/image/post/environment-putty-3.jpeg "putty setp 3")
5. Click `Open` to connect.

## Mac and Linux
0. Download and save the [insecure\_private\_key](https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant) as `insecure_private_key`.
1. Change permission of the file `chmod 0600 insecure_private_key`
1. Login into the test server with ssh as `ssh -i insecure_private_key <username>@<ip-address>`.

# Connect to docker
2. Start virtual docker pseudo cluster by navigating into `~/vm` folder and type `vagrant up` then wait until finish.
3. Connect to docker using `vagrant ssh` in the `vm` folder.
4. Start hadoop and related services with `./start-all.sh`

You will find all sample code in `~/bigdata-bootcamp/sample/`.
