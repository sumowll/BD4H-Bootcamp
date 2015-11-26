---
layout: post
title: Overview of Hadoop
categories: [section]
navigation:
  section: [1, 0]
---

{% objective %}
- To learn basic operations of HDFS.
- To be able to write basic MapReduce program.
- To get to know commonly used tools in Hadoop ecosystem.
{% endobjective %}

[Hadoop](http://hadoop.apache.org) is a framework for distributed storage and processing of very large data sets on computer clusters built from commodity hardware. It's mainly composed of two parts: data storage and data processing. The distributed storage part is handled by the Hadoop Distributed File System (HDFS). The distributed processing part is achieved via MapReduce. On top of HDFS and MapReduce, a bunch of powerful tools have being developed. In this module you will learn the basics about HDFS, MapReduce as well as more advanced Hadoop tools such as HBase, Pig and Hive. 
![hadoop-ecosystem]({{ site.baseurl }}/image/post/hadoop-ecosystem.jpg "Hadoop Tools to Cover")
This chapter is divided into following sections

1. **[Hadoop Basic]({{ site.baseurl }}/hadoop-basic/)**: You will learn basic operations of HDFS, including copy data in/out of HDFS, list available items in HDFS, remove items etc. Also, you will learn how to write a basic MapReduce program in Java to count distinct diagnostic code in order to compute prevalence of diseases in the given dataset.

2. **[Apache HBase]({{ site.baseurl }}/hadoop-hbase/)**: HBase is a powerful distributed NoSQL database inspired by Google BigTable. HBase provides SQL-like syntax to query big data. You will learn typical create, retrieve, update, delete (CRUD) operations.

3. **[Hadoop Streaming]({{ site.baseurl }}/hadoop-streaming)**: Hadoop streaming provides the mechanism to write MapReduce program in any programming language. In this section, you will learn how to do the same count task via Hadoop streaming in python.

4. **[Apache Hive]({{ site.baseurl }}/hadoop-hive)**: Apace Hive provides SQL-like syntax to query data stored in HDFS, HBase etc. Again like Pig, Hive will cover the high-level HiveQL into low-level MapReduce programs. You will learn how to create table and do a simple query using Hive.

5. **[Apache Pig]({{ site.baseurl }}/hadoop-pig)**: Apache Pig is a declarative language to manipulate data using Hadoop. You will learn Pig Latin, the grammer of Pig. Then the Pig system will translate the Pig Latin script into the low-level (often more cumbersome) MapReduce Java programs.

