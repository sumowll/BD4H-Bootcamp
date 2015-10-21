---
layout: post
title: Overview of Hadop
categories: [section]
navigation:
  section: [1, 0]
---

{% objective %}
- Being farmiliar with basic operations of HDFS.
- Being able to write basic MapReduce program.
- Know matual tools in Hadoop ecosystem.
{% endobjective %}

[Hadoop](http://hadoop.apache.org) is a framework for distributed storage and processing of very large data sets on computer clusters built from commodity hardware. It's mainly composed of two parts: data storage and data processing. The distributed storage part is handled by the Hadoop Distributed File System (HDFS). The distributed processing part is achieved via MapReduce. On top of HDFS and MapReduce, a bunch of powerful tools have being developed. In this chapter you will learn the basic Hadoop HDFS, MapReduce knowledge as well as usage of advanced tools like Pig and Hive.

This chapter is divided into following sections

1. **[Hadoop Basic]({{ site.baseurl }}/hadoop-basic/)**: You will learn basic operations of HDFS, including copy data in/out of HDFS, list available items in HDFS, remove items etc. Also, you will learn how to write a basic MapReduce program to count distinct diagnostic code to see prevalence of disease in given dataset.

2. **[Apache HBase]({{ site.baseurl }}/hadoop-hbase/)**: HBase is a powerful distributed NOSql database inspired by Google BigTable. HBase provide SQL-like syntax to query big data. You will learn typical create, retrieve, update, delte (CRUD) operations.

3. **[Hadoop Streaming]({{ site.baseurl }}/hadoop-streaming)**: Hadoop streaming provide the mechanism to write MapReduce program in any programming language. In this section, you will learn how to do the same count task via Hadoop streaming in python.

4. **[Apache Pig]({{ site.baseurl }}/hadoop-pig)**: Apache Pig is a declarative language to manipulate data using Hadoop. You will learn Pig Latin, the grammer of Pig and Pig will translate that into low-level cubersome MapReduce program.

5. **[Apache Hive]({{ site.baseurl }}/hadoop-hive)**: Apace Hive provides SQL-like syntax to query data stored in HDFS, HBase etc. You will learn how to create table and do a simple query.