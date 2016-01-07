---
layout: page
title: UPR Big Data for Healthcare
description: Georgia Tech big data bootcamp training material
---

{% objective %}
Familiar with basic concepts and techniques in big data processing with Apache Spark.
{% endobjective %}

# Survey
After finish the training, please [send feedback to us](
http://goo.gl/forms/50gFjLqYDK) to help us do better in future. Thanks.

# Learning Environment Overview
To faciliate learning, we setup Docker environment for all participants. Below figure illustrate the setup
![docker-env]({{ site.baseurl }}/image/post/docker-environment.jpg "docker environment on AWS")
Basically, each user will have his/her own single node psudeo cluster on top of docker. Within one docker container, all tools like Hadoop, Spark are installed and configured. Several docker containers will share one AWS machine.

# Login onto AWS machine
Before access pseduo cluster, we need to log into AWS machine. Find your username and corresponding AWS machine ip below table. Please remember your user name as we will use that in several places later.

|user name| AWS host IP|
|:--------|:-----------|
|user1 to user5|54.85.161.93|
|user6 to user10|52.91.248.65|
|user11 to user15|54.86.90.155|
|user16 to user20|54.86.12.170|
|user21 to user25|52.90.191.245|


0. Downlaod ans save the [insecure\_private\_key.ppk](https://gist.githubusercontent.com/anonymous/51a1d87c29357120b1ad/raw/95e7bd1450f37c0008a24561dd33f87dcde99420/insecure_private_key.ppk)
1. Download [putty](http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe)
2. Double click to run putty.
3. Input user name and ip address in the format `<username>@<ip-address>` like 
![environment-putty-1]({{ site.baseurl }}/image/post/environment-putty-1.jpeg "putty setp 1")
4. Select the downloaded *insecure\_private\_key.ppk* file as ![environment-putty-2]({{ site.baseurl }}/image/post/environment-putty-2.jpeg "putty setp 2")
6. **Optional** you can save the session by giving a name and click Save like 
![environment-putty-3]({{ site.baseurl }}/image/post/environment-putty-3.jpeg "putty setp 3")
5. Click `Open` to connect.

# Connect to docker

2. Start virtual docker pseudo cluster by navigating into `~/vm` folder and type `vagrant up` then wait until finish.
3. Connect to docker using `vagrant ssh` in the `vm` folder.
4. Start hadoop and related services with `./start-all.sh`

You will find all sample code in `bigdata-bootcamp/sample/`.
