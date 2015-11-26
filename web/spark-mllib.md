---
layout: post
title: Spark MLlib and Scikit-learn
navigation:
  section: [2, 5]
---
{% objective %}
- Understand input to MLlib.
- Can run basic classification algorithms.
- Can export/loas trained model.
- Can develop model with other machine learning module for verification purpose.
{% endobjective %}

In this section, you will learn how to build a heart failure (HF) predictive model step by step using MLlib. We assume you have finished previous [Spark Application]({{ site.baseurl }}/spark-application/) section. You will first learn how to train a model using Spark MLlib and save. Next, you will learn how to achieve same goal using Python Scikit-learn machine learning module for verification purpose.

# MLlib
In this MLlib part, you will first load data and get some high-level summary 
statistics, then train a classifier to prediction heart failure occurrence.

## Load Samples
Loading data from your saved result can be achieved by
``` scala
import org.apache.spark.mllib.util.MLUtils
val data = MLUtils.loadLibSVMFile(sc, "sample")
```

## Basic Statistics
Spark MLlib provides various functions to compute summary statistics that are useful when doing machine learning and data analysis tasks.

```scala
import org.apache.spark.mllib.stat.{MultivariateStatisticalSummary, Statistics}

// colStats() calculates the column statistics for RDD[Vector]
// we need to extract only the features part of each LabeledPoint:
//   RDD[LabeledPoint] => RDD[Vector] 
val summary = Statistics.colStats(data.map(_.features))
  
// summary.mean: a dense vector containing the mean value for each feature (column)
// the mean of the first feature is 0.1
summary.mean(0)

// the variance of the first feature
summary.variance(0)

// the number of non-zero values of the first feature
summary.numNonzeros(0)
```

## Split data
In typical machine learning problem, we need to split data into training (60%) and test (40%) set.

```scala
val splits = data.randomSplit(Array(0.6, 0.4), seed = 0L)
val train = splits(0).cache()
val test = splits(1).cache()
```
## Train classifier
Let's train a linear SVM model using Stochastic Gradient Descent (SGD) on the training set to predict heart failure

```scala
import org.apache.spark.mllib.classification.SVMWithSGD
val numIterations = 100
val model = SVMWithSGD.train(train, numIterations)
```

## Testing
For each sample in the testing set, output a (prediction, label) pair, and calculate the prediction accuracy.
 
```scala
val predictionAndLabel = test.map(x => (model.predict(x.features), x.label))
val accuracy = predictionAndLabel.filter(x => x._1 == x._2).count / test.count.toFloat
println("testing Accuracy  = " + accuracy)
```

## Save & load model
In real world setting, you main need to save trained model. You can achieve that by directly serialize you model and save
```scala
  import java.io.{FileOutputStream, ObjectOutputStream, ObjectInputStream, FileInputStream}
  // save model
  val oos = new ObjectOutputStream(new FileOutputStream("model"))
  oos.writeObject(model)
  oos.close()

  // load model from disk
  val ois = new ObjectInputStream(new FileInputStream("model"))
  val loadedModel = ois.readObject().asInstanceOf[org.apache.spark.mllib.classification.SVMModel]
  ois.close()
```

# Scikit-learn
If your data set is small after feature construction in previous [Spark Application]({{ site.baseurl }}/spark-application/) section, you may consider run machine learning predictive model training test using your farmiliar tools like scikit-learn in Python or some R pckages. Here we show how to do that in Scikit-learn, a Python machine learning library.

## Fetch data
In order to work with Scikit-learn, you will need to take data out of HDFS into local file system. We can get the `samples` folder from your home directory in HDFS and merge content into one single file by below commands in bash
``` bash
hdfs dfs -get samples /tmp/patients
cat /tmp/patients/* > patients.svmlight
```

## Move on with Python
In later steps, you will use python interactive shell. To open a python interfactive shell, just type  `python` in bash. You will get something similar to below sample
``` python
[hang@bootcamp1 ~]$ python
Python 2.7.10 |Continuum Analytics, Inc.| (default, Oct 19 2015, 18:04:42)
[GCC 4.4.7 20120313 (Red Hat 4.4.7-1)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
Anaconda is brought to you by Continuum Analytics.
Please check out: http://continuum.io/thanks and https://anaconda.org
>>>
```
which show version and distribution of the python installation you are using.

## Load and split data
Now we can load data and split it into training and testing set in similar way as above MLlib approach.
```python
from sklearn.cross_validation import train_test_split
from sklearn.datasets import load_svmlight_file

X, y = load_svmlight_file("patients.svmlight")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4, random_state=41)
```


## Train classifier
Let's train a linear SVM model again on the training set to predict heart failure
```python
from sklearn.svm import LinearSVC
model = LinearSVC(C=1.0, random_state=42)
model.fit(X_train, y_train)
```

## Testing
We can get prediction accuracy on testing set as
```python
model.score(X_test, y_test)
```

## Save & load model
We can save and load the trained model via [pickle](https://docs.python.org/2/library/pickle.html) serialization module in Python like
``` python
import pickle
with open('pysvcmodel.pkl', 'wb') as f:
    pickle.dump(model, f)

with open('pysvcmodel.pkl', 'rb') as f:
    loaded_model = pickle.load(f)
```







{% comment %}
# Regression
Suppose now instead of predicting whether a patient has heart failure, we want to predict the total amount of payment for each patient. This is no longer a binary classification problem, because the labels we try to predict are real-valued numbers. In this case, we can use the regression methods in MLlib.

## Construct data
We need to construct a new dataset for this regression problem. The only difference is that we change the label from `heartfailure` (binary) to `PAYMENT` (real value).

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

## Split data
2. Split data into training (60%) and test (40%) set.

```scala
scala> val splits = data.randomSplit(Array(0.6, 0.4), seed = 0L)
scala> val train = splits(0).cache()
scala> val test = splits(1).cache()
```

## Training
Train a linear regression model using SGD on the training set

```scala
import org.apache.spark.mllib.regression.LinearRegressionWithSGD
scala> val numIterations = 100
scala> val model = LinearRegressionWithSGD.train(training, numIterations)
```

## Testing
For each example in the testing set, output a (prediction, label) pair, and calculate the mean squared error.
 
```scala
scala> val predictionAndLabel = test.map(x => (model.predict(x.features), x.label))
scala> val MSE = predictionAndLabel.map{case(p, l) => math.pow((p - l), 2)}.mean()
scala> println("testing Mean Squared Error = " + MSE)
```
{% endcomment %}
