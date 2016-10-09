---
layout: post
title: How to start Zeppelin
categories: [section]
navigation:
  section: [3, 1]
---
{% objective %}
- Learn how to work with Zeppelin Notebook.
{% endobjective %}

## 1. Run provided Docker image
Currently, we are using 0.04.1 for Zeppelin.
If you have not run Docker yet, please run it first.
Please refer to [Docker in Local OS (For Spark 2.0 or Jupyter/Zeppelin Notebook)]({{ site.baseurl }}/env-docker) for more details.

Please check the actual IP assigned to the container. For example in OSX:
```
$ printenv  | grep "DOCKER_HOST"
DOCKER_HOST=tcp://192.168.99.100:2376
```
`192.168.99.100` is assigned IP address.
Then, start actual container, for example in OSX:
```
docker run -it --privileged=true -m 4096m -p 2222:22 -p 8888:8888 -p 8889:8889 -h bootcamp1.docker sunlab/bigdata:0.04.1 /bin/bash
```

## 2. Start Zeppelin service and create HDFS folder
If you have not started Zeppelin service,
```
sudo service zeppelin start
```

We need to create a HDFS folder for the user `zeppelin` as:  
```
sudo su - hdfs
hdfs dfs -mkdir /user/zeppelin
hdfs dfs -chown zeppelin /user/zeppelin
exit
```
You can check whether it has been created or not by using:
```
hdfs dfs -ls /user/
```

## 3. Open Zeppelin Notebook in your browser
Once you have started Zeppelin service and have created HDFS folder for Zeppelin, you can access Zeppelin Notebook by using your local web browser.

Open your web browser, and type in the address:
`host-ip:port-for-zeppelin`
For example,
`192.168.99.100:8889` since the IP address assigned to my Docker container is `192.168.99.100` as it is shown above, and the port number assigned to Zeppelin service is `8889` as default in our Docker image.

Once you navigate to that IP address with the port number, you will see the front page of Zeppelin like:
![zeppelin-frontpage]({{ site.baseurl }}/image/zeppelin/frontpage.png)

Let's move to do a simple tutorial in the next section.
