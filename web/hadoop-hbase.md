---
layout: post
title: Apache HBase
categories: [section]
navigation:
  section: [1, 2]
---

Apache HBase is a distributed column-oriented database built on top of the Hadoop file system. Use HBase when you need random, realtime read/write access to your Big Data. It provides a convenient interactive shell as well as a Java API.

# Interactive Shell
You can start the HBase interactive shell using `hbase shell` command. If HBase is successfully installed in your system, you will get 
```
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.18, rb149f3f0d25c5cd2f195b39fe05d42507fdeabfc, Sat May 23 00:09:16 GMT 2015

hbase(main):001:0> 
```
To exit the interactive shell, type `exit` or `<ctrl+c>`.

1. Checking the status of the cluster
```
hbase(main):001:0> status
(may have some debug messages)
2 servers, 0 dead, 1.0000 average load
```

2. Creating a table

The syntax to create a table in HBase shell is shown below.
```
create 'table name', 'column family'
```

Let's create a table called `hospital` with two column families `id` and `value`.

```
hbase(main):002:0> create 'hospital', 'id', 'value'
```
And it will give you the following output.
```
0 row(s) in 1.1620 seconds
```

3. Listing table(s)

```
hbase(main):003:0> list
TABLE
hospital
1 row(s) in 0.0180 seconds
```

4. Describe and Alter the table

The `describe` command returns the description of the table. 

```
hbase(main):004:0> describe 'hospital'
'hospital', {NAME => 'id', DATA_BLOCK_ENCODING => 'NONE', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => true                                                    
  '0', VERSIONS => '3', COMPRESSION => 'NONE', MIN_VERSIONS => '0', TTL => '2147483647', KEEP_DELETED_                                                         
 CELLS => 'false', BLOCKSIZE => '65536', IN_MEMORY => 'false', ENCODE_ON_DISK => 'true', BLOCKCACHE =>                                                         
  'true'}, {NAME => 'value', DATA_BLOCK_ENCODING => 'NONE', BLOOMFILTER => 'NONE', REPLICATION_SCOPE =                                                         
 > '0', VERSIONS => '3', COMPRESSION => 'NONE', MIN_VERSIONS => '0', TTL => '2147483647', KEEP_DELETED                                                         
 _CELLS => 'false', BLOCKSIZE => '65536', IN_MEMORY => 'false', ENCODE_ON_DISK => 'true', BLOCKCACHE =                                                         
 > 'true'}                                                                                                                                                     
1 row(s) in 0.0350 seconds
```
This shows some basic information for each column family. For example, the `id` column family has block size 65536 and keeps at most 3 versions for each cell (distinguish by timestamp).

We can alter the setting by using `alter`. But we need to first disable the table.

```
hbase(main):005:0> disable 'hospital'
hbase(main):006:0> alter 'hospital', {NAME => 'id', VERSIONS => 5}
```
Don't forget to re-enable after changing the setting.

```
hbase(main):007:0> enable 'hospital'

```

5. Putting data into the table

Using `put` command, you can insert rows into a table. Its syntax is as follows:
```
put 'table name', 'row key', 'colfamily:colname', 'value'
```
For example, let's put a record of a paitent-id.

```
hbase(main):008:0> put 'hospital', 'row1', 'id:patient', 'patient-id-1'
0 row(s) in 0.0140 seconds
```
This puts the value `patient-id-1` in row `row1` and column `patient` (within the column family `id`).
Let's put some more records.
```
hbase(main):009:0> put 'hospital', 'row1', 'id:event', 'event-id-1'
hbase(main):010:0> put 'hospital', 'row1', 'value:value', '1'
hbase(main):011:0> put 'hospital', 'row2', 'id:event', 'event-id-2'
```

6. Reading data 

Using the `scan` command, you can get the table data.

```
hbase(main):012:0> scan 'hospital'
ROW            COLUMN+CELL
 row1          column=id:event, timestamp=1436623001980, value=event-id-1
 row1          column=id:patient, timestamp=1436622532169, value=patient-id-1
 row1          column=value:value, timestamp=1436622642925, value=1
 row2          column=id:event, timestamp=1436623003694, value=event-id-2
2 row(s) in 0.0130 seconds
```

If you only want to know the number of rows, you can use

```
hbase(main):013:0> count 'hospital'
2 row(s) in 0.0130 seconds
```

Using the `get` command, you can get a single row of data at a time.

```
hbase(main):014:0> get 'hospital', 'row1' 
COLUMN                                   CELL
 id:event           timestamp=1436623001980, value=event-id-1
 id:patient         timestamp=1436622532169, value=patient-id-1
 value:value        timestamp=1436622642925, value=1
3 row(s) in 0.0270 seconds
```

We can further specify the column that we want to retrieve.

```
hbase(main):015:0> get 'hospital', 'row1', {COLUMN => 'id:patient'}
 id:patient       timestamp=1436622532169, value=patient-id-1
 1 row(s) in 0.9730 seconds
```

7. Deleting data

You can delete a specific cell in a table by the `delete` command

```
hbase(main):016:0> delete 'hospital', 'row1', 'id:event'
0 row(s) in 0.0100 seconds
```

To delete all the cells in a row, use the `deleteall` command

```
hbase(main):017:0> deleteall 'hospital', 'row1'
0 row(s) in 0.0110 seconds   
```

8. Dropping a Table

Using the drop command, you can delete a table. Before dropping a table, you have to disable it.

```
hbase(main):018:0> disable 'hospital'
0 row(s) in 1.1000 seconds

hbase(main):019:0> drop 'hospital'
```
