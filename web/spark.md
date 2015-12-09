---
layout: post
title: Overview of Spark
categories: [section]
navigation:
  section: [2]
---

{% objective %}
- Know basic Scala syntax.
- Being farmiliar with Spark RDD operations.
- Being able to work with advanced tools on top of Spark.
{% endobjective %}

In this chapter, you will learn the usage of [Spark](http://spark.apache.org), an in-memory spark clustering computing framework for parallel data processing. Due to time limit, we will focus more on interactive shell. Except Spark Streaming, all other components of Spark ecosystem will be covered.
![spark-ecosystem]({{ site.baseurl }}/image/post/spark-ecosystem.jpg "Spark Ecosystem")

Initially, Spark is developed with [Scala](http://www.scala-lang.org/), a functional programming laguage on JVM. Though most of the Spark functions also have Python and Java API, in this course, we will give examples in Scala only for its concise and simplicity. Interested students can learn more about Python and Java in Spark from [official Spark document](https://spark.apache.org/docs/latest/programming-guide.html).

This chapter is logically divided into following sections

1. **[Scala Basic]({{ site.baseurl }}/scala-basic/)**: You will learn/review basic of scala syntax via interactive shell, including declare variables of different types, make function calls etc. How to compile and run a standalone scala program will also be covered.
2. **[Spark Basic]({{ site.baseurl }}/spark-basic/)**: In this section, you will learn how to load data into Spark and how to conduct some basic processing, i.e. converting data from raw string into predefined class, filtering out those items with missing field and count the final. 
3. **[Spark SQL]({{ site.baseurl }}/spark-sql/)**: In this section, you will learn how to use SQL like syntax for data processing in Spark. You will see how the tasks of previous section can be achieved with Spark SQL.
4. **[Spark Application]({{ site.baseurl }}/spark-application/)**: In this section, you will learn how to preprocess data using spark for predictive modeling. Specifically, you will setup data for later heart failure prediction using MLlib and using Scikit-learn python machine learning module.
5. **[Spark MLlib and Scikit-learn]({{ site.baseurl }}/spark-mllib/)**: With pre-processed data you got by following instructions of previous sections, you will have a dataset suitable for Machine Learning task. In this section, you will learn how to apply existing algorithms in MLlib and in Scikit-learn to predict whether patient will have heart disease or not. 
4. **[Spark Graphx]({{ site.baseurl }}/spark-graphx/)**: Grpahx is a specially designed component of Spark for graph data processing. In this section, you will learn how to construct a graph and run PageRank, Connected Components algorithm on the constructed graph.

