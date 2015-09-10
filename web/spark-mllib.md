---
layout: post
title: Spark MLlib
navigation:
  section: [2, 5]
---

# Data Types
For many machine learning tasks, such as classification, regression, and clustering, each data point is often represented as a vector. Each coordinate of the vector corresponds to a particular feature of the data point.

## Vector
MLlib supports two types of vectors: dense and sparse.
A dense vector is basically a `Double` array of length equals to the dimension of the vector.
If a vector contains only a few non-zero entries, we can then more efficiently represent the vector by a sparse vector, which indicates the non-zero indices and the corresponding values.
For example, a vector `(1.0, 0.0, 3.0)` can be represented in dense format as `[1.0, 0.0, 3.0]` or in sparse format as `(3, [0, 1.0], [2, 3.0])`, where 3 is the size of the vector.

The base class of a vectors is `Vector`, and there are two implementations: `DenseVector` and `SparseVector`. We recommend using the factory methods implemented in `Vectors` to create vectors.

```scala
scala> import org.apache.spark.mllib.linalg.{Vector, Vectors}

// Create a dense vector (1.0, 0.0, 3.0).
scala> val dv = Vectors.dense(1.0, 0.0, 3.0)

// Create a sparse vector (1.0, 0.0, 3.0) by specifying its nonzero entries.
scala> val sv = Vectors.sparse(3, Seq((0, 1.0), (2, 3.0)))
```

## Labeled Point
A labeled point is a vector, either dense or sparse, associated with a label/response. In MLlib, labeled points are used in supervised learning algorithms.
For example, in binary classification, a label should be either 0 or 1. For multiclass classification, labels should be class indices starting from zero: 0, 1, 2, .... For regression, a label is a real-valued number.

```scala
scala> import org.apache.spark.mllib.linalg.Vectors
scala> import org.apache.spark.mllib.regression.LabeledPoint

// Create a labeled point with label 1 and a dense feature vector.
scala> val labeled1 = LabeledPoint(1, Vectors.dense(1.0, 0.0, 3.0))

// Create a labeled point with label 0 and a sparse feature vector.
scala> val labeled0 = LabeledPoint(0, Vectors.sparse(3, Seq((0, 1.0), (2, 3.0))))
```

# Pre-processing Data
To apply machine learning algorithms provided in MLlib, we need to transform our data into `RDD[LabeledPoint]`. Recall that our data file is in the following form.

```
00013D2EFD8E45D1,DIAG78820,1166,1.0
00013D2EFD8E45D1,DIAGV4501,1166,1.0
00013D2EFD8E45D1,heartfailure,1166,1.0
00013D2EFD8E45D1,DIAG2720,1166,1.0
....

```
Each line is a 4-tuple `(patient-id, event-id, timestamp, value)`. Suppose now our goal is to predict if a patient will have heart failure. We can use the value associated with the event `heartfailure` as the label. This value can be either 1.0 (the patient has heart failure) or 0.0 (the patient does not have heart failure). We call a patient with heart failure a **positive example**, and a patient without heart failure a **negative example**. 
For example, in the above snippet we can see that patient `00013D2EFD8E45D1` is a positive example. The file **case.csv** consists of only positive examples, and the file **control.csv** consists of only negative examples.


We will use the values associated with events other than `heartfailure` as the feature vector for each patient. Specifically, the length of the vector is the number of distinct `event-id`'s, and each coordinate of the vector stores the value corresponds to a particular event. The values associated with events not shown in the file are assume to be 0. Since each patient typically has only a few hundreds of records (lines) compared to thousands of distinct events, it is more efficient to use `SparseVector`.
Note that each patient can have multiple records with the same `event-id`. In this case we sum up the values associated with a same `event-id`. 

1. Read in the data. The file **case.csv** consists of only positive examples, and the file **control.csv** consists of only negative examples. The function `union` is used to combine the two files. Since the data will be used more than once, we use `cache()` to prevent reading in the file multiple times.

```scala

// read in positive examples (patients with heart failure)
scala> val rawData1 = sc.textFile("case.csv")

// read in negative examples (patients without heart failure)
scala> val rawData2 = sc.textFile("control.csv")

// combine the two files
scala> val rawData = rawData1.union(rawData2).cache()
```

2. Extract the set of distinct `event-id`'s, and assign each of them a consecutive integer value starting from 0. The first step is to extract all `event-id`'s, and then use `distinct()` to eliminate duplicate elements. Then, we append each element in the set a consecutive integer index by calling `zipWithIndex()`. Finally, in order to be used in the next step, it is convenient to transform this set (consists of pairs) into a Scala Map.

```scala
                                // extract the second field in each line
scala> val featureMap = rawData.map( x => x.split(",")(1) ).
                                // eliminate duplicate event-id 
                                distinct().
                                // append each event-id a consecutive integer index
                                // e.g. (DIAG78820, 0), (DIAGV4501, 1), ...
                                zipWithIndex().
                                // make it into a Scala Map(DIAG78820 -> 0, DIAGV4501 -> 1, ...)
                                collectAsMap()

// number of distinct event-id's = length of the feature vector
scala> val numOfFeatures = featureMap.size
```
3. Next, we transform each line `(patient-id, event-id, timestamp, value)` into a key-value pair `((patient-id, feature), value)`, where `feature` is an integer mapped from the original `event-id`. Note that the key in this key-value pair is itself a pair.
Then, we apply `reduceByKey` to sum up `value`'s for each `(user-id, feature)` key. 

```scala
scala> val features = pos.map{ x =>
                        val s = x.split(",")
                        // s(0): parent-id
                        // s(1): event-id
                        // s(2): timestamp
                        // s(3): value

                        // featureMap: event-id (String) => feature (Long)
                        // toInt: convert Long to Int
                        // toDouble: convert String to Double
                        ((s(0), featureMap(s(1)).toInt), s(3).toDouble)
                      }.
                      reduceByKey(_+_)

```

4. In the last step, we transformed each line into `((patient-id, feature), value)`, where `value` is actually an aggregated value. The next step is to group records with the same `patient-id`. To do this, we first transform `((patient-id, feature), value)` into `(patient-id, (feature, value))` and apply `groupByKey`. The `groupByKey` function collects all `(feature, value)` pairs associated with each `patient-id` into a collection of type `Iterable[(Int, Double)]`.

   To construct a `LabeledPont`, we use `find()` to find the value corresponds to `heartfailure` as the label, and then remove this pair from the feature vector.

```scala
scala> val labelID = featureMap("heartfailure")
scala> val data = features.map{ case ((patient, feature), value) =>
                    (patient, (feature, value))
                  }.
                  groupByKey().
                  map{ x =>
                    val label = x._2.find(_._1 == labelID).get()._2
                    val featureNoLabel = x._2.toSeq.filter(_._1 != labelID)
                    LabeledPoint(label, Vectors.sparse(numOfFeatures, featureNoLabel))
                  }
```

# Basic Statistics
Spark provides various functions to compute summary statistics that are useful when doing machine learning and data analysis tasks.

```scala
scala> import org.apache.spark.mllib.stat.{MultivariateStatisticalSummary, Statistics}

// colStats() calculates the column statistics for RDD[Vector]
// we need to extract only the features part of each LabeledPoint:
//   RDD[LabeledPoint] => RDD[Vector] 
scala> val summary = Statistics.colStats(data.map(_.features))
  
// summary.mean: a dense vector containing the mean value for each feature (column)
// the mean of the first feature is 0.1
scala> summary.mean(0)
res: Double = 0.1  

// the variance of the first feature
scala> summary.variance(0)
res: Double = 3.0

// the number of non-zero values of the first feature
scala> summary.numNonzeros(0)
res: Double = 1.0
```

# Classification
We can now train a classifier on the data to predict whether a patient has heart failure.

1. Split data into training (60%) and test (40%) set.

```scala
scala> val splits = data.randomSplit(Array(0.6, 0.4), seed = 0L)
scala> val train = splits(0).cache()
scala> val test = splits(1).cache()
```
2. Train a linear SVM model using Stochastic Gradient Descent (SGD) on the training set

```scala
scala> import org.apache.spark.mllib.classification.SVMWithSGD
scala> val numIterations = 100
scala> val model = SVMWithSGD.train(training, numIterations)
```
3 For each example in the testing set, output a (prediction, label) pair, and calculate the prediction accuracy.
 
```scala
scala> val predictionAndLabel = test.map(x => (model.predict(x.features), x.label))
scala> val accuracy = predictionAndLabel.filter(x => x._1 == x._2).count / test.count.toFloat
scala> println("testing Accuracy  = " + accuracy)
```

# Regression
Suppose now instead of predicting whether a patient has heart failure, we want to predict the total amount of payment for each patient. This is no longer a binary classification problem, because the labels we try to predict are real-valued numbers. In this case, we can use the regression methods in MLlib.

1. We need to construct a new dataset for this regression problem. The only difference is that we change the label from `heartfailure` (binary) to `PAYMENT` (real value).

```scala
scala> val labelID = featureMap("PAYMENT")
scala> val data = features.map{ case ((patient, feature), value) =>
                    (patient, (feature, value))
                  }.
                  groupByKey().
                  map{ x =>
                    val label = x._2.find(_._1 == labelID).get._2
                    val featureNoLabel = x._2.toSeq.filter(_._1 != labelID)
                    LabeledPoint(label, Vectors.sparse(numOfFeatures, featureNoLabel))
                  }
```

2. Split data into training (60%) and test (40%) set.

```scala
scala> val splits = data.randomSplit(Array(0.6, 0.4), seed = 0L)
scala> val train = splits(0).cache()
scala> val test = splits(1).cache()
```

3. Train a linear regression model using SGD on the training set

```scala
import org.apache.spark.mllib.regression.LinearRegressionWithSGD
scala> val numIterations = 100
scala> val model = LinearRegressionWithSGD.train(training, numIterations)
```

4. For each example in the testing set, output a (prediction, label) pair, and calculate the mean squared error.
 
```scala
scala> val predictionAndLabel = test.map(x => (model.predict(x.features), x.label))
scala> val MSE = predictionAndLabel.map{case(p, l) => math.pow((p - .), 2)}.mean()
scala> println("testing Mean Squared Error = " + MSE)
```
