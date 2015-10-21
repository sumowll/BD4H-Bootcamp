---
layout: post
title: Apache Hive
categories: [section]
navigation:
  section: [1, 5]
---

This section shows the basic usage of Hadoop Hive. Hive provides SQL like language HiveQL on top of Hadoop. Instead of writing raw MapReduce program, you can work on data warehouse task using simple farmiliar query language.

# Interactive shell
In the sample code, we will use the data of patient event sequences in tupel format. Let's start the Hive CLI interactive shell first by typing `hive` in command line
```bash
> hive
...                                                                         
[info]
hive> 
```

Before loading data, we first need to define a table just like working with database server with SQL.
```sql
hive> CREATE TABLE events (
    >   patient_id STRING,
    >   event_name STRING,
    >   date_offset INT,
    >   value INT)
    > ROW FORMAT DELIMITED
    > FIELDS TERMINATED BY ','
    > STORED AS TEXTFILE;
OK
Time taken: 0.289 seconds
hive> 
```
And we could check existing tables and schema with commands
``` sql
hive> SHOW TABLES;
OK
events
Time taken: 0.022 seconds, Fetched: 1 row(s)
hive> DESCRIBE events;
OK
patient_id              string                                      
event_name              string                                      
date_offset             int                                         
value                   int                                         
Time taken: 0.221 seconds, Fetched: 4 row(s)
```

Next, let's insert data into the table.
```sql
hive> LOAD DATA LOCAL INPATH 'data'
    > OVERWRITE INTO TABLE events;
Loading data to table default.events
Table default.events stats: [numFiles=2, numRows=0, totalSize=1208972, rawDataSize=0]
OK
Time taken: 0.521 seconds
```

Then we could run SQL we are farmiliar with like
``` sql
hive> SELECT patient_id, count(*) FROM events
    > GROUP BY patient_id;

[info]...

F49EA945C42543C8        19
F4C0BFF334226C29        60
F560829E559E1FEB        13
...
FA4854797F48D537        88
FA831739B546F976        15
FAEF9F6E7AF1D99D        196
FBF4F34C7437373D        119
FBFD014814507B5C        28
Time taken: 20.351 seconds, Fetched: 300 row(s)
```

We could also save query result to local directory
``` sql
hive> INSERT OVERWRITE LOCAL DIRECTORY 'tmp_local_out'
    > ROW FORMAT DELIMITED
    > FIELDS TERMINATED BY ','
    > STORED AS TEXTFILE
    > SELECT patient_id, count(*) 
    > FROM events 
    > GROUP BY patient_id;


[info]...
OK
Time taken: 17.034 seconds
```

You could learn more about the syntax from its [language manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual).

# Besides shell
Besides running commands with interactive shell, you can also run a script. In the `sample/hive` folder, you can run the entire script with
```bash
hive -f sample.hql
```

The content of the script is simply the combination of commands we run in shell with one more statement to drop existing table if necessary
``` sql
DROP TABLE IF EXISTS events;

CREATE TABLE events (
  patient_id STRING,
  event_name STRING,
  date_offset INT,
  value INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

SHOW TABLES;
DESCRIBE events;

LOAD DATA LOCAL INPATH 'data'
OVERWRITE INTO TABLE events;

INSERT OVERWRITE LOCAL DIRECTORY 'tmp_local_out'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
SELECT patient_id, count(*) 
FROM events 
GROUP BY patient_id;
```

Further, it's possible to run [hive as a server](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients) and connect with JDBC or its beeline client.

# Related tools
Hive translate queries into a series of MapReduce jobs, thus not suitable for realtime setting. Alternative tools inspired and influeced by Hive are getting more attention, for example, [Cloudera Impala](http://impala.io/) and [Spark SQL](https://spark.apache.org/sql/).