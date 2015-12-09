---
layout: post
title: Spark Sql
categories: [section]
navigation:
  section: [2, 3]
---
{% objective %}
- Being able to load data into Spark SQL as DataFrame.
- Being able to manipulate data with built-in functions.
- Being able to use User Defined Function(UDF).
{% endobjective %}

# Overview
Recent versions of Spark released the programming abstraction named `DataFrame`, which can be regarded as table in traditional relational database. `DataFrame` is stored in distributed manner so that different rows may locate on different machines. On `DataFrame` you can write `sql` queries, manipulate columns programatically with API etc.

# Loading data
Spark provides API to load data in json, parquet, hive table etc. You can refer to the official [Spark SQL programming guide](https://spark.apache.org/docs/latest/sql-programming-guide.html#data-sources) for those formats. Here we show how to load csv files, we will use the [spark-csv](https://github.com/databricks/spark-csv) module by databricks.

Start spark shell in local mode with below command to add extra dependencies

```
% spark-shell --master "local[2]" --packages com.databricks:spark-csv_2.10:1.0.3
[logs]

Spark context available as sc.
15/05/04 13:12:57 INFO SparkILoop: Created sql context (with Hive support)..
SQL context available as sqlContext.

scala> 
```

Now, load data
```scala
scala> val patientEvents = sqlContext.load("input/", "com.databricks.spark.csv").
     toDF("patientId", "eventId", "date", "rawvalue").
     withColumn("value", 'rawvalue.cast("Double"))
patientEvents: org.apache.spark.sql.DataFrame = [patientId: string, eventId: string, date: string, rawvalue: string, value: double]
```
the first parameter is path to data(in HDFS), and second is a class name, the adapter to load CSV file. Here we specify a directory name so that all files in that directory will be read and second parameter make sure we will the proper parser. Next we call `toDF` to rename the column with meaningful name. Finally, we add one more column that have double type of value instead of string.

# Manipulating data
There are two methods to work with the DataFrame, either using the domain specific language (DSL) or use SQL. 
## SQL
Writing SQL is straight forward assuming you have experience with any relational database.
```scala
scala> patientEvents.registerTempTable("events")
scala> sqlContext.sql("select patientId, eventId, count(*) count from events where eventId like 'DIAG%' group by patientId, eventId order by count desc").collect
res5: Array[org.apache.spark.sql.Row] = Array(...)
```
Here the `patientEvents` DataFrame is registered as a table in sql context so that we could run sql commands. Next line is a standard sql command with `where`, `group by` and `order by` statements.
## DSL
Next, we show how to manipulate data with DSL, same result of previous SQL command can be achieved by
```scala
scala> patientEvents.filter($"eventId".startsWith("DIAG")).groupBy("patientId", "eventId").count.orderBy($"count".desc).show
patientId        eventId   count
00291F39917544B1 DIAG28521 16   
00291F39917544B1 DIAG58881 16   
00291F39917544B1 DIAG2809  13   
00824B6D595BAFB8 DIAG4019  11   
0085B4F55FFA358D DIAG28521 9    
6A8F2B98C1F6F5DA DIAG58881 8    
019E4729585EF3DD DIAG4019  8    
0124E58C3460D3F8 DIAG4019  8    
2D5D3D5F03C8C176 DIAG4019  8    
01A999551906C787 DIAG4019  7    
...
```
For a complete DSL functions, see [DataFrame](http://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.DataFrame) class API.

# Saving data
Spark SQL provides a convenient way to save data in different format just like loading data. For example you can write 

```scala
scala> patientEvents.
    filter($"eventId".startsWith("DIAG")).
    groupBy("patientId", "eventId").
    count.
    orderBy($"count".desc).
    save("aggregated.json", "json")
```
to save your transformed data in `json` format or

```scala
scala> patientEvents.filter($"eventId".startsWith("DIAG")).groupBy("patientId", "eventId").count.orderBy($"count".desc).save("aggregated.csv", "com.databricks.spark.csv")
```
to save  in `csv` format.

# UDF
In some cases, the built-in function of SQL like `count`, `max` is not enough, you can extend it with your own functions. For example, you want to _find_ number of different event types, you can define and use an UDF.

## Define
define and register an UDF
```scala
scala> sqlContext.udf.register("getEventType", (s: String) => s match {
    case diagnostics if diagnostics.startsWith("DIAG") => "diagnostics"
    case "PAYMENT" => "payment"
    case drug if drug.startsWith("DRUG") => "drug"
    case procedure if procedure.startsWith("PROC") => "procedure"
    case "heartfailure" => "heart failure"
    case _ => "unkown"
    })
```

## Use
Write sql and call your function

```scala
scala> sqlContext.sql("select getEventType(eventId) type, count(*) count from events group by getEventType(eventId) order by count desc").show
type          count
drug          16251
diagnostics   10820
payment       3259 
procedure     514  
heart failure 300  
```

{% exercise Find top 10 patients with highest total payment using both SQL and DSL.%}
SQL
```scala
scala> sqlContext.sql("select patientId, sum(value) as payment from events where eventId = 'PAYMENT' group by patientId order by payment desc limit 10").show

patientId        payment
0085B4F55FFA358D 139880.0
019E4729585EF3DD 108980.0
01AC552BE839AB2B 108530.0
0103899F68F866F0 101710.0
00291F39917544B1 99270.0
01A999551906C787 84730.0
01BE015FAF3D32D1 83290.0
002AB71D3224BE66 79850.0
51A115C3BD10C42B 76110.0
01546ADB01630C6C 68190.0
```
{% endexercise %}

