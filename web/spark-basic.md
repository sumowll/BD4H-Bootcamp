---
layout: post
title: Spark Basic
categories: [section]
navigation:
    section: [2, 2]
---

{% objective %}
- Invoking command in Spark interactive shell.
- Familiar with RDD concept.
- Know basic RDD operations.
{% endobjective %}

# Spark Shell
Start the Spark interactive shell by invoking `spark-shell` in terminal. Then you will see
```text
> spark-shell
Using Spark's default log4j profile: org/apache/spark/log4j-defaults.properties
...
[messages]
...
Spark context available as sc.
scala>
```
In Spark, we call the main entrance of program the driver. Here in interactive shell, the Spark shell program is driver. A driver program can access Spark through a `SparkContext` object, which represents a connection to a computing cluster. In above interactive shell, `SparkContext` is already created for you as variable `sc`. You can input `sc` to see its type.
```
scala> sc
res0: org.apache.spark.SparkContext = org.apache.spark.SparkContext@27896d3b
```
{% comment %}
You may find the logging statements that get printed in the shell distracting. You can control the verbosity of the logging. To do this, you can create a file in the conf directory called `log4j.properties`. The Spark developers already include a template for this file called `log4j.properties.template`. To make the logging less verbose, make a copy of `conf/log4j.properties.template` called `conf/log4j.properties` and find the following line:

```
log4j.rootCategory=INFO, console
```
Replace `INFO` with `WARN` so that only WARN messages and above are shown.

{% endcomment %}


# RDD
Resilient Distributed Dataset(RDD) is Spark's core abstraction for working with data. An RDD is simply a fault-tolerant **distributed** collection of elements. In Spark, all work is expressed as either creating new RDDs, transforming existing RDDs, or calling operations on RDDs to compute a result. There are two ways to create RDDs: by distributing a collection of objects (e.g., a list or set), or by referencing a dataset in an external storage system, such as a shared filesystem, HDFS, HBase, or any data source offering a Hadoop InputFormat.

## Parallelized Collections

The simplest way to create an RDD is to take an existing collection (a Scala Seq) in your program and pass it to SparkContext's `parallelize()` method.

```scala
scala> val data = Array(1, 2, 3, 4, 5)
data: Array[Int] = Array(1, 2, 3, 4, 5)

scala> val distData = sc.parallelize(data)
distData: org.apache.spark.rdd.RDD[Int] = ParallelCollectionRDD[2] at parallelize at <console>:23
```
Once created, the distributed dataset (distData) can be operated on in parallel. For example, we can add up the elements by calling `distData.reduce((a, b) => a + b)`. You will see more operations on RDD later on.
{% msgwarning %}
Parallelizing a collection is very useful when you are learning Spark. However, this is not encouraged in real practice since it requires the entire dataset to be in memory of driver program first. Instead, importing data from [external datasets](#external-datasets) should be employed.
{% endmsgwarning %}

## External Datasets
A more common way to create RDDs is to load data from external storage. Below we show how to load data from your local file system.

```scala
scala> val lines = sc.textFile("case.csv")
lines: org.apache.spark.rdd.RDD[String] = README.md MapPartitionsRDD[1] at textFile at <console>:21
```
Here in above example, each line of the original file will become an element in the `lines` RDD.
{% msginfo %}
Reading data from file syetem, Spark relies on HDFS library. In above example we didn't configure HDFS through environmental viarable or configuration file so that data is read from local file system. 
{% endmsginfo %}

# RDD Operations
RDDs offer two types of operations: **transformation** and **actions**:
- **Transformations** are operations on RDDs that return a new RDD, such as `map()` and `filter()`.
- **Actions** are operations that return a result to the driver program or write it to storage, such as `first()` and `count()`.

Spark treats **transformations** and **actions** very differently, so understanding which type of operation you are performing is very important.
You can check whether a function is a transformation or an action by looking at its return type: **transformations** return RDDs, whereas **actions** return some other data type.

All **transformations** in Spark are lazy, in that they do not compute the results right away. Instead, they just remember the operations applied to some base dataset (e.g. an Array or a file). The **transformations** are only computed when an action requires a result to be returned to the driver program.
Therefore, the above command of reading in a file has not actually been executed yet. 
We can force the evaluation of RDDs by calling any **actions**.

Let's go through some common RDD operations by playing with our dataset.
Recall that in the file **case.csv**, each line is a 4-filed tuple `(patient-id, event-id, timestamp, value)`.

## Count
We can count the number of lines in the input file using `count` operation, i.e.

```scala
scala> lines.count()
res1: Long = 14046
```
Clearly, `count` is an **action**.
## Take

Let us take a peek at the data. The `take(k)` will return the first k elements in the RDD. Spark also provides `collect()` which brings all the elements in the RDD back to the driver program. Note that it is only used when the data is small. Both `take` and `collect` are **actions**.

```scala
scala> lines.take(5)
res2: Array[String] = Array(00013D2EFD8E45D1,DIAG78820,1166,1.0, 00013D2EFD8E45D1,DIAGV4501,1166,1.0, 00013D2EFD8E45D1,heartfailure,1166,1.0, 00013D2EFD8E45D1,DIAG2720,1166,1.0, 00013D2EFD8E45D1,DIAG4019,1166,1.0)  
```
We got the first 5 records in this RDD. However, this is hard to read. We can make it more readable by traversing the array to print each record on its own line. 

```scala
scala> lines.take(5).foreach(println)
00013D2EFD8E45D1,DIAG78820,1166,1.0
00013D2EFD8E45D1,DIAGV4501,1166,1.0
00013D2EFD8E45D1,heartfailure,1166,1.0
00013D2EFD8E45D1,DIAG2720,1166,1.0
00013D2EFD8E45D1,DIAG4019,1166,1.0
```
Note that during the above 3 commands, the RDD `lines` has been computed (i.e. read in from file) 3 times. We can prevent this by calling `lines.cache()`, which will cache the RDD in memory.

{% exercise Print `event-id` for the first 5 records %}
```scala
scala> lines.take(5).foreach(x => println(x.split(",")(1)))
```
{% endexercise %}


## Map
The `map` operation in Spark is similar to that of Hadoop. It's a **transformation** that transforms each item in the RDD into a new item by performing the provided function. For example, in order to get IDs of loaded patients, we use `map` like
```scala
scala> lines.map(line => line.split(",")(0))
```

It is also possible to write a more complexity, multiple-lines map function. In this case, curly braces should be used in place of parentheses. For example, we can get both `patient-id` and `event-id`. 
```scala
scala> lines.map{line =>
  val s = line.split(",")
  (s(0), s(1))
}
```

## Filter
As indicated by it's name, `filter` can **transform** an RDD to another by filtering out elements that satisfy given condition. For example, we can count the number of records for a particular patients by using the `filter` function.
```scala
scala> lines.filter(line => line.contains("00013D2EFD8E45D1")).count()
res4: Long = 200
```

## Distinct
`distinct` is a `transformation` that transform a RDD to another by eliminating duplications. We can use that to calculate the number of distinct patients. In order to do this, we first extract the patient ID from each line.
We use the `map()` function, In this example, we transform each line into the corresponding patient ID by extracting only the first column. We then eliminate duplicate IDs by the `distinct()` function.

```scala
scala> lines.map(line => line.split(",")(0)).distinct().count()
res5: Long = 100
```

## Reduce
Spark provides a similar operation of reduce in MapReduce, `reduceByKey`. This name is more informative. It *transform* an `RDD[(K, V)]` into `RDD[(K, List[V])]` and aggregate on `List[V]` to get `RDD[(K, V)]`. Suppose now we want to calculate the total payment by each patients. A payment record in the dataset is in the form of `(patient-id, PAYMENT, timestamp, value)`.
```scala
scala> val payments = lines.filter(line => line.contains("PAYMENT")).
                                 map{ x =>
                                   val s = x.split(",")
                                   (s(0), s(3).toFloat)
                                 }.reduceByKey(_+_)
```

The RDD returned by `filter` contains those records associated with payment. Each item is then transformed to a key-value pair `(patient-id, amount)` with `map`. Because each patient can have multiple payments, we need to use `reduceByKey` to sum up the payments for each patient. Here in this example, `patient-id` will be key, and `amount` be value to aggregate.

We can then show the top-3 patients with the highest payment using `sortBy` first.

```scala
scala> payments.sortBy(_._2, false).take(3).foreach(println)
```

```
(0085B4F55FFA358D,139880.0)
(019E4729585EF3DD,108980.0)
(01AC552BE839AB2B,108530.0)
```

## Statistics
For RDD consists of numeric values, Spark provides some useful statistical primitives.

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

## Set Operation
RDDs support many of the operations of mathematical sets, such as `union` and `intersection`, even when the RDDs themselves are not properly sets. For example, we can combine the two files by the `union` fucntion. Please notice that `union` here is not strictly identical to union operation in mathmatics as Spark will not remove duplication.

```scala
scala> val lines2 = sc.textFile("control.csv")
scala> lines.union(lines2).count() 
res11: Long = 31144 

```

# Further Reading
For the complete list of RDD operations, please see the 
[Spark Programming Guide](https://spark.apache.org/docs/latest/programming-guide.html#rdd-operations).
