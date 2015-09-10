---
layout: post
title: Scala Basic
categories: [section]
navigation:
  section: [2, 1]
---
This section will briefly go through the essential knowledge about scala for later Spark training. In this section we will first show how to work with spark shell, then show how use variables, functions with examples. Finally, we give instructions about how to compile and run a standalone program using `sbt`.

# Spark Shell
Open a terminal and navigate to the root of code samples. You could open a scala shell by typing `scala`. Or, you could use [sbt](http://www.scala-sbt.org/index.html) by typing `sbt/sbt console`. The second approach will help you add your project source code and dependencies into class path, so that your functions or library functions will be available for you to try to in the interactive shell. 

Start the scala shell you will see
```scala
$ sbt console
[info]...

Welcome to Scala version 2.10.4 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0).
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```
type `:quit` to stop the shell.

# Variables
You could decalre a variable like
```scala
scala> val myInt = 1 + 1
myInt: Int = 2

scala> myInt = 3
```
where `val` is a key word in `scala` that make the variable immutable. If you reassign a value to `myInt`, error will be reported.
```scala
scala> myInt = 3
<console>:8: error: reassignment to val
       myInt = 3
             ^

scala> 
```
Instead, variable declared with `var` is mutable. In real practice, we try to use  `val` instead of `var` if possible as a good practice of functional programming.
```scala
scala> var myString = "Hello Big Data"
myString: String = Hello Big Data

scala> myString = "Hello Scala"
myString: String = Hello Scala
```
Looks like we are working with script language like Javascript or Python, no variable type is specified. In fact, `scala` is static type language and the compiler implicitly infered the type. You could always specify a type as
```scala
scala> val myDouble: Double = 3
myDouble: Double = 3.0
```
Beside `Int`, `Double` and `String`. Built-in variable types of Scala you may need in this training include
```scala
scala> val myList: List[String] = List("this", "is", "a", "list", "of", "string")
myList: List[String] = List(this, is, a, list, of, string)

scala> val myTuple:(Double, Double) = (1.0, 2.0)
myTuple: (Double, Double) = (1.0,2.0)
```

# Functions
You could define a function and call into it
```scala
scala> def triple(x: Int): Int = {
     | x*3
     | }
triple: (x: Int)Int

scala> triple(2)
res0: Int = 6
```
Where `x: Int` is parameter and type, the second `Int` is function return type. There's not explicit `return` statement, the result of last expresssion `x*3` will be returned. In this example, as there are only one expression and return type could be infered by compiler, you could define function as
```scala
def triple(x: Int) = x*3
```

Scala is object-oriented, function calls on a class method is straight forward like most OO language
```scala
scala> myString.lastIndexOf("Scala")
res1: Int = 6
```
If the function do not have parameters, you could call it without parenthesis
```scala
scala> myInt.toString
res2: String = 2
```
You could also define an anonymous function and pass it to variable like lambda expression in some other language:
```scala
scala> val increaseOne = (x: Int) => x + 1
increaseOne: Int => Int = <function1>

scala> increaseOne(3)
res3: Int = 4
```
Anonymous function is very useful when a simple funtion will be passed as parameter to a function call
```scala
scala> myList.foreach{item: String => println(item)}
this
is
a
list
of
string
```
where `item: String => println(item)` is an anonymous function. This function call be simpled to 
```scala
scala> myList.foreach(println(_))
```
where `_` will represent first parameter. You could even write `myList.foreach(println)` only.

# Class
Declare class in scala could be as simple as 
```scala
scala> class Patient(val name: String, val id: Int)
defined class Patient

scala> val patient = new Partial
PartialOrdering    PartiallyOrdered   

scala> val patient = new Partial
PartialOrdering    PartiallyOrdered   

scala> val patient = new Patient("Bob", 1)
patient: Patient = Patient@755f5e80

scala> patient.name
res13: String = Bob
```

A special kind of class we will use is [`Case Class`](http://www.scala-lang.org/old/node/107). `Case Class` could be declared as 
```scala
scala> case class Patient(val name: String, val id: Int)
```
It's very convenient to use case class in pattern matting
```scala
scala> val p = new Patient("Abc", 1)
p: Patient = Patient(Abc,1)

scala> p match {case Patient("Abc", id) => println(s"matching id is $id")}
matching id is 1
```

# Standalone Program
Working with large real world application, you usually need to compile and package your source code with some tools. Here we show how to compile and run a simple program with [sbt](http://www.scala-sbt.org/index.html). Run the sample code in 'hello-bigdata' folder
```
% sbt/sbt run
Attempting to fetch sbt
######################################################################## 100.0%
Launching sbt from sbt/sbt-launch-0.13.8.jar
[info] .....
[info] Done updating.
[info] Compiling 1 Scala source to ./hello-bigdata/target/scala-2.10/classes...
[info] Running Hello 
Hello bigdata
[success] Total time: 2 s, completed May 3, 2015 8:42:48 PM
```
the source code file `hello.scals` is compiled and invoked.

# Further Reading
This is a very brief overview of important Scala language features required for the training. We highly recommend the readers to checkout below references

- [Twitter Scala School](https://twitter.github.io/scala_school/index.html)
- [Official Scala Tutorial](http://docs.scala-lang.org/tutorials/?_ga=1.128323084.1826222080.1429310377)
- [sbt tutorial](http://www.scala-sbt.org/0.13/tutorial/index.html)