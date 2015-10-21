---
layout: post
title: Hadoop Basic
categories: [section]
navigation:
  section: [1, 1]
---

{% objective %}
- Being farmiliar with basic operations of HDFS.
- Being able to write basic MapReduce program.
{% endobjective %}

# HDFS Operations
Hadoop provides a command line utility `hdfs` to interact with HDFS. Basic operations are placed under `hdfs dfs` subcommand. Let's play with some basic operations.

## Create directory
Similar to creating local directory via linux command `mkdir`, creating a folder named `input` in HDFS use
```
> hdfs dfs -mkdir input
```
where `hdfs` is the HDFS utility, `dfs` is subcommad to handle basic HDFS operation,  `-mkdir` means you want to create a directory and directory name is specified as `input`. Above command actually create the `input` directory in your home directory of HDFS, which by default shold be `/user/your_name/`. Of course, you can create it to other place with absolute or relative path.

## Copy data in and out
Suppose you followed previous instrucion and created an directory named `input`, you can copy data from local file system to HDFS using `-put`. For example,

```
> hdfs dfs -put case.csv input
> hdfs dfs -put control.csv input
```
You can find these two files as described in [sample data]({{ site.baseurl }}/data/).

Corresponds to `-put`, `-get` operation will copy data out of HDFS. For example
```
hdfs dfs -get input/case.csv local_case.csv
```
will copy the `input/case.csv` file out HDFS into current working directory using a new name `local_case.csv`. If you didn't specify `local_case.csv`, the original name `case.csv` will be kept.

## List File Information
Just like linux `ls` command, `-ls` is the operation to list files and folders in HDFS. For example, below command list items in your home directory of HDFS(i.e `/user/your_name/`)
```
> hdfs dfs -ls
Found 1 items
-rwxr-xr-x   - hadoop supergroup          0 2015-07-11 06:10 input
```
You can see the newly created `input` directory is listed. You can also see the files inside a particular directory
```
>hdfs dfs -ls input
found 2 items
-rw-r--r--   1 hadoop supergroup     536404 2015-07-11 06:10 input/case.csv
-rw-r--r--   1 hadoop supergroup     672568 2015-07-11 06:08 input/control.csv
```

## Fetch file content
Actually you don't need to copy file out first to see its content, you can directly use `-cat` to printing the content of files in HDFS. For example, below command print out content of the one file you just put into HDFS.
```
hdfs dfs -cat input/case.csv 
```
You will find wildcard character is very useful since output of MapReduce and other Hadoop based tools tends to be directory. For example, to print content of all csv files(the case.csv and control.csv) in `input` HDFS folder, you can
```
hdfs dfs -cat input/*.csv 
```

## Further reading
For more detailed usage of different commands and parameters, you can type
```
hdfs dfs -help
```

{% exercise Remove what you just created.%}
```
hdfs dfs -rm -r input
```
You may miss the `-r` option and get error. `-r` tells HDFS to remove recursively. This is similar to linux command `rm`.
{% endexercise %}

# MapReduce
MapReduce works by breaking the processing into two phases: the map phase and the reduce phase. Each phase has key-value pairs as input and output, the types of which can be chosen by the user. As user, you need to define the `map` and `reducer` operations.

Let's write a simple MapReduce program in Java to calculate the frequency of each `event-id` in our **case.csv** file described in [sample data]({{ site.baseurl }}/data/).

A MapReduce program consists of three parts:
1. A Mapper Class
2. A Reducer Class
3. A main function that tells Hadoop to use the classes we created.

## Mapper
Create a Java file `FrequencyMapper.java`. The FrequencyMapper class extends the predefined `Mapper` class and overwrite the `map` function.

```java
import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class FrequencyMapper
  extends Mapper<LongWritable, Text, Text, IntWritable> {

  private final static IntWritable one = new IntWritable(1);

  @Override
  public void map(LongWritable offset, Text lineText, Context context)
      throws IOException, InterruptedException {

    String line = lineText.toString();
    String eventID = line.split(",")[1];
    context.write(new Text(eventID), one);
  }
}
```

The 4-tuple ` <LongWritable, Text, Text, IntWritable> ` specifies that the inpur key-value pair is of type `<LongWritable, Text>` and the output key-value type is of type `<Text, IntWritable>`.
Since the input files are plain text, we use the input key-value pair of type `<LongWritable, Text>`. The key is the offset of the start of each line, which is not used here. The value is the actual text in the corresponding line.

We use `toString()` to transform the Hadoop `Text` object into the more familiar Java `String` object and extract only the second field of the line (recall that each line is in the form of `patient-id, event-id, timestamp, value`). We then call `context.write` to write the output. Each `line` will be mapped to a pair as `(event-id, 1)`, where 1 is of type IntWritable. Since 1 is a constant, we use a static variable to store it. 

## Reducer
Hadoop internally performs a shuffling process to ensure that the output of the mapper with a same key (same `event-id` in our problem) will go to a same reducer. A reducer thus receives a key and a collection of corresponding values (Java `Iterable` object). In our case the key-value pair is `(event-id, [1,1,...,1])`.

Create a Java file `FrequencyReducer.java`. The FrequencyReducer class extends the predefined `Reducer` class and overwrite the `reduce` function.

```java
import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class FrequencyReducer extends Reducer<Text ,  IntWritable ,  Text ,  IntWritable > {
     @Override public void reduce( Text eventID,  Iterable<IntWritable> counts,  Context context)
         throws IOException,  InterruptedException {

      int sum  = 0;
      for ( IntWritable count  : counts) {
        sum  += count.get();
      }
      context.write(eventID,  new IntWritable(sum));
    }
}

```
The 4-typle `<Text ,  IntWritable ,  Text ,  IntWritable >` specifies the types of the input and output key-value pair.
Note that the type of the input key-value pair (`<Text ,  IntWritable>`) is the same as the output key-value pair of the mapper.

## Main function
Write a Java file `Frequency.java` that runs the MapReduce job.

```java
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Frequency {

  public static void main(String[] args) throws Exception {
    if (args.length != 2) {
      System.err.println("Usage: Frequency <input path> <output path>");
      System.exit(-1);
    }

    // create a Hadoop job and set the main class
    Job job = Job.getInstance();
    job.setJarByClass(Frequency.class);
    job.setJobName("Frequency");

    // set the input and output path
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));

    // set the Mapper and Reducer class
    job.setMapperClass(FrequencyMapper.class);
    job.setReducerClass(FrequencyReducer.class);

    // specify the type of the output
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);

    // run the job
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
```

## Compile and Run
You can find all source code in `sample/hadoop` folder. You will need to navigate to that folder first, then compile, creat jar and run.

### Compile
Compile the three java files with `javac`
```
javac -cp $(hadoop classpath) -d Frequency FrequencyMapper.java FrequencyReducer.java Frequency.java 
```
where `hadoop classpath` outputs the required class path to compile a Hadoop program. `-d classes` puts the generated classes into the `classes` directory. You will  see three class files in the `classes` directory now.


### Create JAR
Let's create a jar named `Frequency.jar` using classes we just compiled.
```
jar -cvf Frequency.jar -C classes/ .
```

{% msginfo %}
In real world application development, you will not need to compile files manually one by one then create jar. Instead, build tools like Maven, Gradle, SBT will be employed.
{% endmsginfo %}

### Run
You can run the jar file just created with
```
hadoop jar Frequency.jar Frequency input output
```
where `Frequency.jar` is named of jar file, `Frequency` is java class to run. `input` and `output` are parameters to the `Frequency` class we implemented. Please be careful that `input` and `output` are used as path in HDFS.

While the program is running, you will see a lot of messages. After the job finishes, you can check the results in the `output` directory (created by Hadoop) by 

```
hdfs dfs -ls output
hdfs dfs -cat output/*
```
You will get results like
```
DIAG03812       2
DIAG03819       1
DIAG0420        1
DIAG0539        2
DIAG05443       1
DIAG06640       1
DIAG07032       1
DIAG1120        5
...
```
The order may not be the same.

### Clean up

If you run the job again, you will see an error message saying the `output` directory already exists. This prevents a user to accidentally overwrite a file. You can remove the directory by
```
hdfs dfs -rm -r output
```
