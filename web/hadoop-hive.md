---
layout: post
title: Hadoop Hive
categories: [section]
navigation:
  section: [1, 4]
---
{% objective %}
- Learn how to work with the Hive interactive shell.
- Learn how to create tables in Hive.
- Learn how to load data into Hive tables.
- Learn how to run basic Hive querys.
{% endobjective %}

This section shows the basic usage of Hadoop Hive. Hive uses a SQL-like language called `HiveQL`, and runs on top of Hadoop. Instead of writing raw MapReduce programs, Hive allows you to perform data warehouse tasks using a simple and familiar query language. After completing this section, you will be able to use `HiveQL` to query big data.

# Interactive shell
In the sample code below we will continue to use the same event tuple [patient data]({{ site.baseurl }}/data/). Let's start the Hive CLI interactive shell first by typing `hive` in the command line.
```bash
> cd bigdata-bootcamp/sample/hive
> hive
...                                                                         
[info]
hive> 
```

# Create table
Before loading data, we first need to define a table just like we would if we were working with a database server such as SQL.
```sql
hive> CREATE TABLE events (
        patient_id STRING,
        event_name STRING,
        date_offset INT,
        value INT)
      ROW FORMAT DELIMITED
      FIELDS TERMINATED BY ','
      STORED AS TEXTFILE;
OK
Time taken: 0.289 seconds
hive> 
```
And you can check existing tables and schema with the commands `SHOW TABLES;` and `DESCRIBE table_name;` respectively.
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

# Load data
Next we'll insert data into the table.
```sql
hive> LOAD DATA LOCAL INPATH 'data'
      OVERWRITE INTO TABLE events;
Loading data to table default.events
Table default.events stats: [numFiles=2, numRows=0, totalSize=1208972, rawDataSize=0]
OK
Time taken: 0.521 seconds
```

# Query
## Basic
With the data loaded you can run familiar SQL statements like:
``` sql
hive> SELECT patient_id, count(*) FROM events
      GROUP BY patient_id;

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

## Save result
You can also save query results to local directory (in the local file system):
``` sql
hive> INSERT OVERWRITE LOCAL DIRECTORY 'tmp_local_out'
      ROW FORMAT DELIMITED
      FIELDS TERMINATED BY ','
      STORED AS TEXTFILE
      SELECT patient_id, count(*) 
      FROM events 
      GROUP BY patient_id;


[info]...
OK
Time taken: 17.034 seconds
```

You can learn more about Hive syntax from the [language manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual).

# Besides shell
Besides running commands with the interactive shell, you can also run a script in batch mode automatically. For example, in the `sample/hive` folder, you can run the entire `sample.hql` script with the command:
```bash
> hive -f sample.hql
```

The contents of the script is simply all of the commands that we ran in the shell, with one additional statement to drop existing table if necessary:
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

Furthermore, it's also possible to run [hive as a server](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients) and connect to the server with JDBC or with its beeline client.

# Related tools
Hive translate queries into a series of MapReduce jobs, therefore it is not suitable for real-time use cases. Alternative tools inspired and influenced by Hive are getting more attention lately, for example, [Cloudera Impala](http://impala.io/) and [Spark SQL](https://spark.apache.org/sql/).