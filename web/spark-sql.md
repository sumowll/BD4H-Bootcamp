---
layout: post
title: Spark Sql
categories: [section]
navigation:
  section: [2, 3]
---

In this section, you will learn how to use Spark SQL to manipulate data. We first give an overview, then we show how to load, transform and save data.

# Overview
Recent versions of Spark released the programming abstraction named DataFrame, which could be regarded as table in traiditional relational database. DataFrame is stored in distributed manner so that different rows may locate on different machines. On DataFrame you could write `sql` queries, manipulate columns programmingly etc.

# Loading data
Spark provide API to load data in json, parquet, hive table etc. You could refer to the official [Spark SQL programming guide](https://spark.apache.org/docs/latest/sql-programming-guide.html#data-sources) for those formats. Here we show how to load csv files, we will use the [spark-csv](https://github.com/databricks/spark-csv) module by databricks.

Start spark shell with below command to add extra dependencies

```
% spark/bin/spark-shell --packages com.databricks:spark-csv_2.10:1.0.3
[logs]

Spark context available as sc.
15/05/04 13:12:57 INFO SparkILoop: Created sql context (with Hive support)..
SQL context available as sqlContext.

scala> 
```

Now, load data
```scala
scala> val patientEvents = sqlContext.load("data/", "com.databricks.spark.csv").
     toDF("patientId", "eventId", "date", "value")
patientEvents: org.apache.spark.sql.DataFrame = [patientId: string, eventId: string, date: string, value: string]
```
the first parameter is path to data, and second is data source. Here we specify a directory name so that all files in that directory will be read and second parameter make sure we will the proper parser. Next we call `toDF` to rename the column with meaningful name.

# Manipulating data
There are two methods to work with the DataFrame, either using the domain specific language (DSL) or use SQL. Writing SQL is straight forward assuming you have experience with any relational database.
```scala
scala> patientEvents.registerTempTable("events")
scala> sqlContext.sql("select patientId, eventId, count(*) count from events where eventId like 'DIAG%' group by patientId, eventId order by count desc").collect
res5: Array[org.apache.spark.sql.Row] = Array(...)
```
Here the `patientEvents` DataFrame is registered as a table in sql context so that we could run sql commands. Next line is a standard sql command with `where`, `group by` and `sort by` statements.

Next, we show how to manipulate data with DSL, same result of previous SQL command could be achieved by
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
# Saving data
Spark SQL provides a convenient way to save data in different format just like loading data. For example you could write 

```scala
scala> patientEvents.
    filter($"eventId".startsWith("DIAG")).
    groupBy("patientId", "eventId").
    count.
    orderBy($"count".desc).
    save("aggregated.json", "json")
```

or

```scala
scala> patientEvents.filter($"eventId".startsWith("DIAG")).groupBy("patientId", "eventId").count.orderBy($"count".desc).save("aggregated.csv", "com.databricks.spark.csv")
```

to save your transformed data in `json` or `csv` format respectively.

# User defiend function (UDF)
In some cases, the built-in function of SQL like `count`, `max` if not enough, you could write your own function. For example, you want to _find_ number of different event types, you could:

1. define and register an UDF

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

2. write sql and call your function

    ```scala
    scala> sqlContext.sql("select getEventType(eventId) type, count(*) count from events group by getEventType(eventId) order by count desc").show
    type          count
    drug          16251
    diagnostics   10820
    payment       3259 
    procedure     514  
    heart failure 300  
    ```
