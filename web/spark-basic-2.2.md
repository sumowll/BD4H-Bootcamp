---
layout: post
title: Spark 2.2 Basics
categories: [section]
navigation:
    section: [3, 6]
---

{% objective %}
- Understand Dataset abstraction above and beyond RDD
{% endobjective %}

# Overview
Spark < 1.6 was largely bound to working solely with RDD strucutures and encodable DataFrames.  Beginning in 1.6 Datasets were introduced 
which represented a reworking of DataFrames and introduced structured types.

A Dataset has a concrete type of a Scala primitive type (Integer, Long, Boolean, etc) or a subclass of a Product - a case class.  The case class is preferred for Spark because it handles
the serialization code for you thus allowing Spark to shuffle data between workers.  This can additional be handled implementing Externalizable which is a much more efficient mechanism to handle serialization, or by using a compact serializer like Kryos.

Additionally, Spark no longer uses SparkContext directly but prefers the use of a SparkSession that encapsulates a SparkContext and a SqlContext.  The SparkSession is a member of the `sql` package.

There is a wealth of great documentation on the Spark development site.

# Creation of datasets

Datasets can be created explicitly or loaded form a source (e.g. file, stream, parquet, etc).  

```
case class Person(firstName: String, lastName:String)

// wire-in spark implicits
import spark.implicits._

case class Person(firstName: String, lastName: String)

val ds = Seq(Person("Daniel", "Williams")).toDS()

// here you can perform operations that are deferred until an action is invoked.
// creates a anonymous lambda that looks at the 
// firstName of the Dataset[Person] type and invokes a collect
// to pull data back to the driver as an Array[Person]
// the foreach then will invoke a println on each Person
// instance and implicit apply the toString operation that is 
// held in the Product trait
ds.filter(_.firstName == "Daniel").collect().foreach(println)

```


