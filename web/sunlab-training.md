---
layout: page
title: Sunlab Big Data Training
description: Georgia Tech big data bootcamp training material
---

{% objective %}
Familiar with basic concepts and techniques in big data processing.
{% endobjective %}

With increased adoption of Electonic Healthcare Records(EHR) system, more and more EHR data are accumulated. As members of Sunlab, we need to be farmiliar with basic operations to handle big data. Throught the training, you will learn tools in the Hadoop and Spark ecosystem.

# Environment
To faciliate learning, we setup Docker environment for all participants. Please make sure you submitted attandence confirmation to [Google Form](http://goo.gl/forms/dldUHgQoWV). Otherwise we may havn't create learning environment for you. If you already did that, please

0. Download and save the [insecure\_private\_key](https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant) as `insecure_private_key`.
1. Login into the test server with ssh as `ssh -i insecure_private_key <username>@52.90.230.115`.
2. Start virtual docker pseudo cluster by navigating into `vm` folder and type `vagrant up`.
3. Connect to docker using `vagrant ssh` in the `vm` folder.
4. Start hadoop with `./start-all.sh`

You will find all sample code in `bigdata-bootcamp/sample/`.

# Create HDFS home
When you first login, you may want to create home folder for your user name. You can achieve that by

1. switch to `hdfs` user, who is admin of HDFS, by `sudo su - hdfs`.
2. create a folder, i.e. `hdfs dfs -mkdir /user/hang`, remember to replace `hang` as your actual linux `<username>`.
3. change ownership of the new folder to yourself with `hdfs dfs -chown <username> /user/<username>`
4. type `exit` to resume your user rather than `hdfs` user.

# Trouble shooting
**TODO**