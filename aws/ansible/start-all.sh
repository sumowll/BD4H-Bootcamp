#!/bin/bash

sudo service sshd start
sudo /sbin/service hadoop-hdfs-namenode start
sudo /sbin/service hadoop-hdfs-datanode start
sudo /sbin/service hadoop-yarn-resourcemanager start
sudo /sbin/service hadoop-yarn-nodemanager start
sudo /sbin/service hadoop-mapreduce-historyserver start
sudo /sbin/service spark-worker start
sudo /sbin/service spark-master start
sudo /sbin/service hadoop-yarn-proxyserver start
