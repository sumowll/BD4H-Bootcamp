---
layout: post
title: Spark Basic
categories: [section]
navigation:
section: [2, 2]
---

# Spark Interactive Shell
Start the Spark interactive shell by typing the command in the Spark directory.

```scala
bin/spark-shell
```

You may find the logging statements that get printed in the shell distracting. You can control the verbosity of the logging. To do this, you can create a file in the conf directory called `log4j.properties`. The Spark developers already include a template for this file called `log4j.properties.template`. To make the logging less verbose, make a copy of `conf/log4j.properties.template` called `conf/log4j.properties` and find the following line:

```
log4j.rootCategory=INFO, console
```

Replace `INFO` with `WARN` so that only WARN messages and above are shown.


A driver program can access Spark through a `SparkContext` object, which represents a connection to a computing cluster. In the interactive shell, `SparkContext` is already created for you as variable `sc`. Try printing out `sc` to see its type.

```scala
scala> sc
res0: org.apache.spark.SparkContext = org.apache.spark.SparkContext@87860de
```

# Resilient Distributed Datasets (RDDs)
RDD is Spark's core abstraction for working with data. An RDD is simply a fault-tolerant distributed collection of elements. In Spark, all work is expressed as either creating new RDDs, transforming existing RDDs, or calling operations on RDDs to compute a result. There are two ways to create RDDs: by distributing a collection of objects (e.g., a list or set), or by referencing a dataset in an external storage system, such as a shared filesystem, HDFS, HBase, or any data source offering a Hadoop InputFormat.

## Parallelized Collections

The simplest way to create an RDD is to take an existing collection (a Scala Seq) in your program and pass it to SparkContext's `parallelize()` method.

```scala
scala> val data = Array(1, 2, 3, 4, 5)
data: Array[Int] = Array(1, 2, 3, 4, 5)

scala> val distData = sc.parallelize(data)
distData: org.apache.spark.rdd.RDD[Int] = ParallelCollectionRDD[2] at parallelize at <console>:23
```
Once created, the distributed dataset (distData) can be operated on in parallel. For example, we can add up the elements by calling `distData.reduce((a, b) => a + b)`. You will see more operations on RDD later on.
This approach is very useful when you are learning Spark. However, this is not widely used in practice since it requires the entire dataset to be in memory on one machine.


## External Datasets
A more common way to create RDDs is to load data from external storage. Below we show how to load data from your local file system.

```scala
scala> val lines = sc.textFile("case.csv")
lines: org.apache.spark.rdd.RDD[String] = README.md MapPartitionsRDD[1] at textFile at <console>:21
```

# RDD Operations
RDDs offer two types of operations: **transformation** and **actions**. 
Transformations are operations on RDDs that return a new RDD, such as `map()` and `filter()`.
Actions are operations that return a result to the driver program or write it to storage, such as `first()` and `count()`.
Spark treats transformations and actions very differently, so understanding which type of operation you are performing is very important.
You can check whether a function is a transformation or an action by looking at its return type: transformations return RDDs, whereas actions return some other data type.

All transformations in Spark are lazy, in that they do not compute the results right away. Instead, they just remember the operations applied to some base dataset (e.g. an Array or a file). The transformations are only computed when an action requires a result to be returned to the driver program.
Therefore, the above command of reading in a file has not actually been executed yet. 
We can force the evaluation of RDDs by calling any actions.

Let's go through some common RDD operations by playing with our dataset.
Recall that in the file **case.csv**, each line is a 4-tuple `patient-id, event-id, timestamp, value`.


1. Count the number of lines in the input file

```scala
scala> lines.count()
res1: Long = 14046
```
2. Let us take a peek at the data. The `take(k)` will return the first k elements in the RDD. Spark also provides `collect()` which brings all the elements in the RDD back to the driver program. Note that it is only used when the data is small.

```scala
scala> lines.take(5)
```

```
res2: Array[String] = Array(00013D2EFD8E45D1,DIAG78820,1166,1.0, 00013D2EFD8E45D1,DIAGV4501,1166,1.0, 00013D2EFD8E45D1,heartfailure,1166,1.0, 00013D2EFD8E45D1,DIAG2720,1166,1.0, 00013D2EFD8E45D1,DIAG4019,1166,1.0)  
```

We got the first 5 records in this RDD. However, this is hard to read. We can make it more readable by traversing the array to print each record on its own line. 

```scala
scala> lines.take(5).foreach(println)
```

```
00013D2EFD8E45D1,DIAG78820,1166,1.0
00013D2EFD8E45D1,DIAGV4501,1166,1.0
00013D2EFD8E45D1,heartfailure,1166,1.0
00013D2EFD8E45D1,DIAG2720,1166,1.0
00013D2EFD8E45D1,DIAG4019,1166,1.0
```
Note that during the above 3 commands, the RDD `lines` has been computed (i.e. read in from file) 3 times. We can prevent this by calling `lines.cache()`, which will cache the RDD in memory.

3. We can count the number of records for a particular patients by using the `filter` function.
```scala
scala> lines.filter(line => line.contains("00013D2EFD8E45D1")).count()
res4: Long = 200
```

4. We can also calculate the number of distinct patients.
In order to do this, we first extract the patient ID from each line.
We use the `map()` function, which transforms each item in the RDD into a new item by performing the provided function. In this example, we transform each line into the corresponding patient ID by extracting only the first column. We then eliminate duplicate IDs by the `distinct()` function.

```scala
scala> lines.map(line => line.split(",")(0)).distinct().count()
res5: Long = 100
```

5. Suppose now we want to calculate the total payment by each patients. A payment record in the dataset is in the form of `(patient-id, PAYMENT, timestamp, value)`.
```scala
scala> val payments = lines.filter(line => line.contains("PAYMENT")).
                                 map{ x =>
                                   val s = x.split(",")
                                   (s(0), s(3).toFloat)
                                 }.reduceByKey(_+_)
```

The RDD returned by `filter` contains those records associated with payment. Each item is then transformed to a key-value pair `(patient-id, amount)`. Because each patient can have multiple payments, we need to use `reduceByKey` to sum up the payments for each patient.

We can then show the top-3 patients with the highest payment.

```scala
scala> payments.sortBy(_._2, false).take(3).foreach(println)
```

```
(0085B4F55FFA358D,139880.0)
(019E4729585EF3DD,108980.0)
(01AC552BE839AB2B,108530.0)
```

6. For RDD consists of numeric values, Spark provides some useful statistical primitives.

```scala
scala> val payment_values = payments.map(payment => payment._2).cache()
scala> payment_values.max()
res6: Float = 139880.0

scala> payment_values.min()
res7: Float = 3910.0

scala> payment_values.sum()
res8: Double = 2842480.0

scala> payment_values.mean()
res9: Double = 28424.8  

scala> payment_values.stdev()
res10: Double = 26337.091771112468
```

7. RDDs support many of the operations of mathematical sets, such as `union` and `intersection`, even when the RDDs themselves are not properly sets. For example, we can combine the two files by the `union` fucntion.

```scala
scala> val lines2 = sc.textFile("control.csv")
scala> lines.union(lines2).count() 
res11: Long = 31144 

```

For the complete list of RDD operations, please see the 
[Spark Programming Guide](https://spark.apache.org/docs/latest/programming-guide.html#rdd-operations).
