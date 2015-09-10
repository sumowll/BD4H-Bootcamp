---
layout: post
title: Spark GraphX
categories: [section]
navigation:
  section: [2, 4]
---

In this section, we show how to create a graph with patient and diagnostic code. Then, we show how to run algorithms on the the newly created graph.

# Basic concept
Spark GraphX abstracts the graph as a concept named property graph, which means that each edge and vertex is associated with some property. The `Graph` class has below definition


```scala
class Graph[VD, ED] {
  val vertices: VertexRDD[VD]
  val edges: EdgeRDD[ED]
}
```

We could regard `VertexRDD[VD]` as RDD of `(VertexID, VD)` tuple and `EdgeRDD[ED]` as RDD of `(VertexID, VertexID, ED)`.

# Graph construction
Let's create a graph of patients and diagnostic codes. For each patient we could assign its patient id as vertex property, and for each diagnostic code, we will the code as vertex property. For the edge between patient and diagnostic code, we will use number of times the patient is diagnosed with given disease.

1. define  necessary data structure and import

    ```scala
    import org.apache.spark.SparkContext._
    import org.apache.spark.graphx._
    import org.apache.spark.rdd.RDD

    abstract class VertexProperty extends Serializable
    
    case class PatientProperty(patientId: String) extends VertexProperty
    
    case class DiagnosticProperty(icd9code: String) extends VertexProperty

    case class PatientEvent(patientId: String, eventName: String, date: Int, value: Double)
    ```

2. load patient event data and filter out diagnostic related only
    
    ```scala
    val allEvents = sc.textFile("data/").
        map(_.split(",")).
        map(splits => PatientEvent(splits(0), splits(1), splits(2).toInt, splits(3).toDouble))

    // get and cache dianosticEvents as we will reuse
    val diagnosticEvents = allEvents.
        filter(_.eventName.startsWith("DIAG")).cache()
    ```

3. create patient vertex

    ```scala
    // create patient vertex
    val patientVertexIdRDD = diagnosticEvents.
        map(_.patientId).  
        distinct.            // get distinct patient ids
        zipWithIndex         // assign an index as vertex id

    val patient2VertexId = patientVertexIdRDD.collect.toMap
    val patientVertex = patientVertexIdRDD.
        map{case(patientId, index) => (index, PatientProperty(patientId))}.
        asInstanceOf[RDD[(VertexId, VertexProperty)]]
    ```

    Notice that in order to assign an unique ID for each vertex, we finally `collect` all the patient to `VertrexID` mapping. Theoritically this is not an efficient practice. One could mitigate uniqueness of ID by calculating ID directly with Hash.

4. create diagnostic code vertex

    ```scala
    // create diagnostic code vertex
    val startIndex = patient2VertexId.size
    val diagnosticVertexIdRDD = diagnosticEvents.
        map(_.eventName).
        distinct.
        zipWithIndex.
        map{case(icd9code, zeroBasedIndex) => 
            (icd9code, zeroBasedIndex + startIndex)} // make sure no confilic with patient vertex id

    val diagnostic2VertexId = diagnosticVertexIdRDD.collect.toMap

    val diagnosticVertex = diagnosticVertexIdRDD.
        map{case(icd9code, index) => (index, DiagnosticProperty(icd9code))}.
        asInstanceOf[RDD[(VertexId, VertexProperty)]]
    ```

    Here we assign vertex id by adding the result of `zipWithIndex` with an offset obtained from previous patient vertex to avoid ID confilication between patient and diagnostic code.

5. create edges 

    ```scala
    val bcPatient2VertexId = sc.broadcast(patient2VertexId)
    val bcDiagnostic2VertexId = sc.broadcast(diagnostic2VertexId)

    val edges = diagnosticEvents.
        map(event => ((event.patientId, event.eventName), 1)).
        reduceByKey(_ + _).
        map{case((patientId, icd9code), count) => (patientId, icd9code, count)}.
        map{case(patientId, icd9code, count) => Edge(
            bcPatient2VertexId.value(patientId),
            bcDiagnostic2VertexId.value(icd9code),
            count
        )}
    ```

    We first broadcast patient and diagnostic code to vertext id mappting. Broadcast could avoid uncessary copy in distributed setting thus will be more effecient. Then we count occurrence of `(patient-id, icd-9-code)` pairs with `map` and `reduceByKey`, finally we translate them to proper `VertexID`.

6. put it together to create the graph

    ```scala
    val vertices = sc.union(patientVertex, diagnosticVertex)
    val graph = Graph(vertices, edges)
    ```

# Graph operation
Given the graph we created, we could run some basic graph operations.
## Connected components
[Connected component][connected-component-wiki] could help find disconnected subgraphs. GraphX provide the API to get connected components as below

```scala
val connectedComponents = graph.connectedComponents
```

The return result is a graph and assigned components of original graph is stored as `VertexProperty`. For example

```scala
scala> connectedComponents.vertices.take(5)
Array[(org.apache.spark.graphx.VertexId, org.apache.spark.graphx.VertexId)] = 
Array((2556,0), (1260,0), (1410,0), (324,0), (180,0))
```

The first element of the tuple is `VertexID` identical to original graph. The second element in the tuple is `connected component` represented by smalled `VertexID` in that component. In above example, five vertices belong to same component.

We could easily get number of connected components using operations on RDD as below.

```scala
scala> connectedComponents.vertices.map(_._2).distinct.collect
Array[org.apache.spark.graphx.VertexId] = Array(0, 169, 239)
```

## Degree
The property graph abstraction of GraphX is directed graph. It provides computation of in-dgree, out-degree and total degree. For example, we could get degrees as

```scala
val inDegrees = graph.inDegrees
val outDegrees = graph.outDegrees
val totalDegrees = graph.degrees
```

## PageRank
GraphX also provides implementation of the famous [PageRank] algorithm, which could compute the 'importance' of a vertex. The graph we generated above is a bipartite graph and not suitable for PageRank. To gve an example of PageRank, we randomly generate a graph and run fixed iteration of PageRank algorithm on it.

```scala
import org.apache.spark.graphx.util.GraphGenerators

val randomGraph = Graph[Int, Int] = 
   GraphGenerators.logNormalGraph(sc, numVertices = 100)

val pagerank = randomGraph.staticPageRank(20)
```

Or, we could run PageRank util converge with tolerance as `0.01` using `randomGraph.pageRank(0.01)`

# Application
Next, we show some how we could ultilize the graph operations to solve some practical problems in the healthcare domain.

## Explore comorbidities
[Comorbidity] is additional disorders co-occuring with primary disease. We know all the case patients have heart failure, we could explore possible comorbidities as below (see comments for more explaination)

```scala
// get all the case patients
val casePatients = allEvents.
    filter(event => event.eventName == "heartfailure" && event.value == 1.0).
    map(_.patientId).
    collect.
    toSet

// broadcast
val scCasePatients = sc.broadcast(casePatients)

//filter the graph with subGraph operation
val filteredGraph = graph.subgraph(vpred = {case(id, attr) =>
        val isPatient = attr.isInstanceOf[PatientProperty]
        val patient = if(isPatient) attr.asInstanceOf[PatientProperty] else null
        // return true iff. isn't patient or is case patient
        !isPatient || (scCasePatients.value contains patient.patientId)
    })

//calculate indegrees and get top vertices
val top5ComorbidityVertices = filteredGraph.inDegrees.
        takeOrdered(5)(scala.Ordering.by(-_._2))
```
We have
```
top5ComorbidityVertices: Array[(org.apache.spark.graphx.VertexId, Int)] = Array((3129,86), (335,63), (857,58), (2048,49), (669,48))
```

And we could check the vertex of index 3129 in original graph is

```
scala> graph.vertices.filter(_._1 == 3129).collect
Array[(org.apache.spark.graphx.VertexId, VertexProperty)] = 
Array((3129,DiagnosticProperty(DIAG4019)))
```

The 4019 code correponds to [Hypertension](http://www.hipaaspace.com/Medical_Billing/Coding/ICD-9/Diagnosis/4019), which is reasonable.

## Similar patients
Given a patient diagnostic graph, we could also find similar patients. One of the most straightforward approach is shortest path on the graph.

```scala
val sssp = graph.
    mapVertices((id, _) => if (id == 0L) 0.0 else Double.PositiveInfinity).
    pregel(Double.PositiveInfinity)(
        (id, dist, newDist) => math.min(dist, newDist), // Vertex Program
        triplet => {  // Send Message
            var msg: Iterator[(org.apache.spark.graphx.VertexId, Double)] = Iterator.empty
            if (triplet.srcAttr + 1 < triplet.dstAttr) {
                msg = msg ++ Iterator((triplet.dstId, triplet.srcAttr + 1))
            }

            if (triplet.dstAttr + 1 < triplet.srcAttr) {
                msg = msg ++ Iterator((triplet.srcId, triplet.dstAttr + 1))
            }
            println(msg)
            msg
        },
        (a,b) => math.min(a,b) // Merge Message
    )

// get top 5 most similar
sssp.vertices.filter(_._2 < Double.PositiveInfinity).filter(_._1 < 300).takeOrdered(5)(scala.Ordering.by(-_._2))
```

[Comorbidity]: http://en.wikipedia.org/wiki/Comorbidity
[pagerank]: http://en.wikipedia.org/wiki/PageRank
[connected-component-wiki]: http://en.wikipedia.org/wiki/Connected_component_\(