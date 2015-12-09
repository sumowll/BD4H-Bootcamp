---
layout: post
title: Scala Basic
categories: [section]
navigation:
  section: [2, 1]
---
{% objective %}
- Know how to work with scala interactive shell.
- Understand `var` and `val` and why prefer `val`.
- Can define variables.
- Can define functions and make function calls.
- Can define class.
- Know Simple Build Tool(SBT).
{% endobjective %}

This section will briefly go through the essential knowledge about scala for later Spark training. In this section we will first show how to work with scala shell, then show how use variables, functions with examples. Finally, we give instructions about how to compile and run a standalone program using `sbt`.

# Scala Shell
Open a terminal and navigate to the root of code samples. You can open a scala shell by typing `scala`. Or, you can use [sbt](http://www.scala-sbt.org/index.html) by typing `sbt console`. The second approach will help you add your project source code and dependencies into class path, so that your functions or library functions will be available for you to try to in the interactive shell. 

Start the scala shell you will see
```scala
$ sbt console
[info]...

Welcome to Scala version 2.10.4 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0).
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```
You can type `:quit` to stop and quit the shell, but don't do that now. We will show operations in the shell in following material.

# Variables
## Declare `val` and `var`
In Scala, there are two types of variable, mutable and immutable. Unlike some functional programming language that requires immutable variable, Scala allows existence of mutable variable but immutable is recommended as it's easier to verify the correctness of your program. Suppose you are still in the scala intertive shell. Define a immutable variable as
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
{% msgwarning %}
In interactive shell, it's possible to redefine variable with same name. In scala source code file, it's not allowed.

```scala
scala> val a = 1
a: Int = 1

scala> val a = 2
a: Int = 2
```
{% endmsgwarning %}

Instead, variable declared with `var` is mutable. In real practice, we try to use `val` instead of `var` if possible as a good practice of functional programming. 

{% msginfo %}
You may have concern that maybe finally many immutable variables will be declared. Actually, with chained function calls, that situation is not the case for well organized code.
{% endmsginfo %}

An example of mutable variable is
```scala
scala> var myString = "Hello Big Data"
myString: String = Hello Big Data

scala> myString = "Hello Scala"
myString: String = Hello Scala
```

## Type
It looks like we are working with script language like Javascript or Python, as no variable type is specified explicitly. In fact, `scala` is static type language and the compiler can implicitly infer the type in most cases. However, you can always specify a type as
```scala
scala> val myDouble: Double = 3
myDouble: Double = 3.0
```
It's always encouraged to do so unless it's too obvious like declare a variable with built-in basic type.

Beside `Int`, `Double` and `String`, built-in variable types of Scala you will need in this training is `List` and `Tuple`
```scala
scala> val myList: List[String] = List("this", "is", "a", "list", "of", "string")
myList: List[String] = List(this, is, a, list, of, string)

scala> val myTuple:(Double, Double) = (1.0, 2.0)
myTuple: (Double, Double) = (1.0,2.0)
```
Here the `List[String]` is syntax of generics in Scala, which is same as `C#`. In above example, `List[String]` means a `List` of `String` and `(Double, Double)` means a two-field tuple type and both the 1st element and 2nd element should be of type `Double`.

# Functions
You can define a function and call into it like
```scala
scala> def triple(x: Int): Int = {
          x*3
       }
triple: (x: Int)Int

scala> triple(2)
res0: Int = 6
```
Where `x: Int` is parameter and its type, and the second `Int` is function return type. There's not explicit `return` statement, but the result of last expresssion `x*3` will be returned like `Ruby`. In this example, as there is only one expression and return type can be infered by compiler, you may define function as
```scala
def triple(x: Int) = x*3
```

Scala is object-oriented, function calls on a class method is straight forward like most OO languages(i.e. Java, C#)
```scala
scala> myString.lastIndexOf("Scala")
res1: Int = 6
```
If the function do not have parameters, you can even call it without parenthesis
```scala
scala> myInt.toString
res2: String = 2
```
You can also define an anonymous function and pass it to variable like lambda expression in some other languages:

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
where `item: String => println(item)` is an anonymous function. This function call be further simplified to 
```scala
scala> myList.foreach(println(_))
scala> myList.foreach(println)
```
where `_` represent first parameter of the anonymous function with body `println(_)`. Additional `_` will represent other parameters. For example, we can calculate the total payment a patient made by
```scala
scala> val payments = List(1, 2, 3, 4, 5, 6)
payments: List[Int] = List(1, 2, 3, 4, 5, 6)

scala> payments.reduce(_ + _)
res0: Int = 21
```
In above example, `reduce` will aggregate `List[A]` into `A` and we defined the aggregator as `_ + _` to sum them up. Of course, you can write that more explicit like
```scala
scala> payments.reduce((a, b)=> a+b)
res1: Int = 21
```
Here we use an import higher order function in functional programming, `reduce`. It can be illustrated with below figure where a function _f_ is applied to one element at a time and the result together with next element will be parameter of next call until end of list recursively.
![functional-reduce]({{ site.baseurl }}/image/post/scala-reduce.png "Reduce Recursive") 
It's important to remember that for `reduce` operation/function, input is `List[V]` and output is `V`, same `V`. Interested reader can learn more from [wiki](https://en.wikipedia.org/wiki/Fold_\(higher-order_function\)). In contrast to `reduce`, you can of course write code using `for` loop, which is verbose and very rare in Scala,
```scala
scala> var totalPayment = 0
totalPayment: Int = 0

scala> for (payment <- payments) {
         totalPayment += payment
       }

scala> totalPayment
res2: Int = 21

scala>
```

{% msginfo %}
Partial function and placeholder syntax is an advanced topic of Scala programming language. It's hard to master within short period of time. For this tutorial, we will use that in simple cases like the sum operation above.
{% endmsginfo %}

# Class
Declaration of a class in scala is as simple as 
```scala
scala> class Patient(val name: String, val id: Int)
defined class Patient

scala> val patient = new Patient("Bob", 1)
patient: Patient = Patient@755f5e80

scala> patient.name
res13: String = Bob
```

Here we see the succinct syntax of Scala again. `class Patient(val name: String, val id: Int)` not only defined constructor of `Patient` but also defined two member varialbles(`name` and `id`). 

A special kind of class we will use a lot is [`Case Class`](http://www.scala-lang.org/old/node/107). `Case Class` can be declared as 
```scala
scala> case class Patient(val name: String, val id: Int)
```
and see below [Pattern Matching](#pattern-matching) for use case.

# Pattern Matching
You may know the `switch..case` in other language. Scala provides a more flexible and powerful technique, `Pattern Matching`. Below example shows one can match by value, by type in one match.
```scala
val payment:Any = 21
payment match {
    case p: String => println("payment is a String")
    case p: Int if p > 30 => println("payment > 30")
    case p: Int if p ==0 => println("zero payment")
    case _ => println("otherwise")
}
```
It's very convenient to use case class in pattern matching
```scala
scala> val p = new Patient("Abc", 1)
p: Patient = Patient(Abc,1)

scala> p match {case Patient("Abc", id) => println(s"matching id is $id")}
matching id is 1
```
Here we not only matched `p` as `Patient` type, but also matched patient name and extracted one member field from the `Patient` class instance.
{% exercise Add default case to above `match` example %}
```scala
p match {
    case Patient("Abc", id) => println(s"matching id is $id")
    case _ => println("not matched")
}
```
{% endexercise %}

# Standalone Program
Working with large real world application, you usually need to compile and package your source code with some tools. Here we show how to compile and run a simple program with [sbt](http://www.scala-sbt.org/index.html). Run the sample code in 'hello-bigdata' folder
```
% cd ~/bigdata-bootcamp/sample/hello-bigdata
% sbt run
Attempting to fetch sbt
######################################################################## 100.0%
Launching sbt from sbt-launch-0.13.8.jar
[info] .....
[info] Done updating.
[info] Compiling 1 Scala source to ./hello-bigdata/target/scala-2.10/classes...
[info] Running Hello 
Hello bigdata
[success] Total time: 2 s, completed May 3, 2015 8:42:48 PM
```
the source code file `hello.scala` is compiled and invoked.

# Further Reading
This is a very brief overview of important Scala language features required for the training. We highly recommend readers to checkout below references to get a bettern understanding of `Scala` programming language.

- [Twitter Scala School](https://twitter.github.io/scala_school/index.html)
- [Official Scala Tutorial](http://docs.scala-lang.org/tutorials/?_ga=1.128323084.1826222080.1429310377)
- [SBT tutorial](http://www.scala-sbt.org/0.13/tutorial/index.html)