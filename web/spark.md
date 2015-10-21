---
layout: post
title: Overview of Spark
categories: [section]
navigation:
  section: [2]
---

{% objective %}
- hi this is learning objective
- objective 2.
{% endobjective %}

{% exercise hi this is test %}
hi
>this
> > is
> > test

``` scala
val x = 2l
```
ad
{% endexercise %}
{% exercise hi this is another test %}
xxxx antoerh
{% endexercise %}

In this chapter, you will learn the usage of [Spark](http://spark.apache.org), an in-memory spark clustering computing framework for parallel data processing. Due to time limit, we will focus more on interactive shell. 

Initially, Spark is developed with [Scala](http://www.scala-lang.org/), a functional programming laguage on JVM. Though most of the Spark functions also have Python and Java API, in this course, we will give examples in Scala only for its concise and simplicity. Interested students could learn more about Python and Java in Spark from [Spark document](https://spark.apache.org/docs/latest/programming-guide.html).

This chapter is divided into following sections

1. **[Scala Basic]({{ site.baseurl }}/scala-basic/)**: You will learn/review basic of scala via interactive shell, including declare variables of different types, make function calls etc. How to compile and run a standalone program will also be covered.
2. **[Spark Basic]({{ site.baseurl }}/spark-basic/)**: In this section, you will learn how to load data into Spark and how to do some basic processing, i.e. convert data from raw string into some defined class, filter out those items with missing field and count the final. 
3. **[Spark SQL]({{ site.baseurl }}/spark-sql/)**: In this section, you will learn how to use SQL for data processing in Spark. You will see how the tasks of previous section could be achieved using SQL.
4. **[Spark Graphx]({{ site.baseurl }}/spark-graphx/)**: Grpahx is a special designed component of Spark for graph data processing. In this section, you will learn how to how to construct a graph and run PageRank, Connected Components algorithm on the graph.
5. **[Spark MLlib]({{ site.baseurl }}/spark-mllib/)**: With pre-processed data you got by following instructions of previous sections, you will have a dataset suitable for Machine Learning task. In this section, you will learn how to convert data you have into feature vectors and how to apply existing algorithms in MLlib to predict whether patient will have heart disease or not. 
