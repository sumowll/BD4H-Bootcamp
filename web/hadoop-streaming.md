---
layout: post
title: Hadoop Streaming
categories: [section]
navigation:
  section: [1, 3]
---
{% objective %}
- Know how to work with Hadoop Streaming.
- Can write Hadoop Streaming program using python.
{% endobjective %}

In this section, you will learn how to work with Hadoop Streaming, a mechanism to run any executable in Hadoop MapReduce. We will show how to count the frequency of different `eventname` in a patient [event sequence file]({{ site.baseurl }}/data/). We show the examples in Python code, but you will find it's straightforward to adapt to other languages.

# Mapper and Reducer
Streaming works by passing data mapper/reducer written in other programming language through standard input and output. Let's first have a look at the source code[^1] of mapper and reducer respectively.

## Mapper
The source code of mapper is
```python
#!/usr/bin/env python

import sys

for line in sys.stdin:
    line        = line.strip()
    splits      = line.split(',')

    if len(splits) != 4:
        # ignore problemactic line
        continue

    # unwind the splits
    patient_id, event_name, date_offset, value = splits

    # emit key-value pair seperated by \t for all events
    print event_name + '\\' + '1'
```
The script read lines from  standard input and with some simple processing output the `event_name` as key and `1` as value to standard output.

## Reducer
Reducer is a little bit complex. The output of mapper will be shuffled by Hadoop framework and reduder will get a list of key-value pairs. The framework gunrantee that key-value pairs of same key will go to same reducer instance.

```python
#!/usr/bin/env python

import sys

current_event = None
current_count = 0
event_name = None

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    event_name, count = line.split('\t', 1)

    # convert count (currently a string) to int
    try:
        count = int(count)
    except ValueError:
        # count was not a number, so silently
        # ignore/discard this line
        continue

    # line is sorted with key (event name)
    if current_event == event_name:
        # same key accumulate
        current_count += count
    else:
        # a new key to work on
        if current_event:
            # write result to STDOUT
            print '%s\t%s' % (current_event, current_count)
        current_count = count
        current_event = event_name

# do not forget to output the last event_name if needed!
if current_event == event_name:
    print '%s\t%s' % (current_event, current_count)
```
This piece of code check the boundaries of sorted input and sum up values from same key.

# How to run
## Local test
Before running it in Hadoop, it's more convenient to test that in shell with `cat` and `sort` commands. You will need to navigate to _sample/hadoop-streaming_ folder. Then, run below command in shell
```bash
cat data/* | python mapper.py | sort | python reducer.py                       
```
You will get results like
```
DIAG0043        1
DIAG00845       8
DIAG0086        1
DIAG0088        4
DIAG01190       1
DIAG0201        1
DIAG0202        1
DIAG0204        1
DIAG0221        1
DIAG0232        1
...
```
It works as expected, now we could run it in Hadoop. 

## Hadoop
We first need to put data into HDFS then run hadoop
```
hdfs dfs -put data/ /streaming-data
hadoop jar hadoop-streaming.jar \
   -files mapper.py,reducer.py \
   -mapper "python mapper.py" \
   -reducer "python reducer.py" \
   -input /streaming-data \
   -output /streaming-output
```

We can check the result and clean up now.
``` bash
# check result
hdfs dfs -ls /streaming-output
hdfs dfs -cat /streaming-output/*

# clean up
hdfs dfs -rm -r /streaming-output
hdfs dfs -rm -r /streaming-data
```
{% exercise Update mapper and reducer to output diagnostic code occurred more than once %}
You will need to update both mapper and reducer, for mapper
```python
# emit key-value pair seperated by \t for all diagnostic code
if event_name.startswith('DIAG'):
    print event_name + '\\' + '1'
```
and reducer looks like
```python
#!/usr/bin/env python

import sys

current_event = None
current_count = 0
event_name = None

for line in sys.stdin:
    # remove leading and trailing whitespace
    line = line.strip()

    # parse the input we got from mapper.py
    event_name, count = line.split('\t', 1)

    # convert count (currently a string) to int
    try:
        count = int(count)
    except ValueError:
        # count was not a number, so silently
        # ignore/discard this line
        continue

    # line is sorted with key (event name)
    if current_event == event_name:
        # same key accumulate
        current_count += count
    else:
        # a new key to work on
        if current_event and current_count > 1:
            # write result to STDOUT
            print '%s\t%s' % (current_event, current_count)
        current_count = count
        current_event = event_name

# do not forget to output the last event_name if needed!
if current_event == event_name and current_count > 1:
    print '%s\t%s' % (current_event, current_count)
```{% endexercise %}
# Further reading
Streaming is a good machanism to reuse existing code. Wrapping existing code to work with Hadoop can be simplified with framework like [mrjob](https://github.com/Yelp/mrjob) and [Luigi](http://luigi.readthedocs.org/en/latest/index.html) for Python. You can find more explaination and description of Streaming from its [offical document](http://hadoop.apache.org/docs/r1.2.1/streaming.html).

[^1]: this example is adapted from [Michael G. Noll blog](http://www.michael-noll.com/tutorials/writing-an-hadoop-mapreduce-program-in-python/), copyright to original author.

