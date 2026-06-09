# Manufacturing (Parte 1)

## Challenge 1

> [!NOTE] Assignment
> Explore **the path of a specific manufacturing process**.  
> Use `process_id:"Prod1"` to select the process.

```cypher
MATCH p1=((:Process {process_id:"Prod1"})<-[:IS_INSTANCE_OF]-(j:Job))
OPTIONAL MATCH p2=((j)-[:DEPENDS_ON]->*(:Job))
RETURN p1, p2
```

Alternatively, if you want to visualize also the machines required for each job, you can use the following query:

```cypher
MATCH p1=((:Process {process_id:"Prod1"})<-[:IS_INSTANCE_OF]-(j:Job)-[:RUNS_ON]->(:Machine))
OPTIONAL MATCH p2=((j)-[:DEPENDS_ON]->*(:Job)-[:RUNS_ON]->(:Machine))
RETURN p1, p2
```

## Challenge 2

> [!NOTE] Assignment
> Visualize **the job queue of a machine**.

```cypher
MATCH (m:Machine)-[:QUEUE_HEAD]->(t1:Job)
OPTIONAL MATCH p=((m)<-[:RUNS_ON]-(t1)<-[:WAITS]-*())
RETURN p
```

Alternatively, if a you want to explicitly know the end of the queue, you can use the following query.  
This will show a sort of loop, indicating both the head and the tail of the queue.

```cypher
MATCH p=((m:Machine)-[:QUEUE_HEAD]->(:Job)<-[:WAITS]-*(:Job)<-[:QUEUE_TAIL]-(m))
RETURN p
```

## Challenge 3

> [!NOTE] Assignment
> Find **not completed jobs** (for each process).  
> Note that the pending status can be due both to logical dependencies (`DEPENDS_ON`) and to delays (`WAITS`).

```cypher
MATCH (j:Job)
WHERE j.status <> "Completed"
OPTIONAL MATCH p=((j)<-[:DEPENDS_ON|WAITS]-*(:Job)-[:IS_INSTANCE_OF]->(:Process))
RETURN p
```

## Challenge 4

> [!NOTE] Assignment
> Compute the **critical path** and the **residual estimated time**.  
> To simplify the query, compute them for process `Prod3`.

To get the critical path (the chain of jobs which are not completed yet), it is possible to use the following query:

```cypher
MATCH p1=((:Process {process_id:"Prod3"})<-[:IS_INSTANCE_OF]-(j1:Job))
WHERE j1.status <> "Completed"
OPTIONAL MATCH p2=((j)-[:DEPENDS_ON|WAITS]->*(j2:Job))
WHERE j2.status <> "Completed"
RETURN p1, p2
```

To get the duration, it is necessary to group nodes into a list and use the `reduce()` function, as it is shown in the
following query:

```cypher
MATCH p1=((:Process {process_id:"Prod3"})<-[:IS_INSTANCE_OF]-(j1:Job))
WHERE j1.status <> "Completed"
OPTIONAL MATCH p2=((j)-[:DEPENDS_ON|WAITS]->*(j2:Job))
WHERE j2.status <> "Completed"
WITH p1, p2, nodes(p2) AS jobs
WITH p1, p2, reduce(duration=0, job in jobs | duration + job.duration * (1-job.completion_progress)) AS total_duration
RETURN p1, p2, total_duration
ORDER BY total_duration DESC
LIMIT 1
```

To get a better presentation, we can slightly modify the query.  
The final version of it is the following one:

```cypher
MATCH (process:Process {process_id:"Prod3"})<-[:IS_INSTANCE_OF]-(j1:Job)
WHERE j1.status <> "Completed"
OPTIONAL MATCH p2=((j)-[:DEPENDS_ON|WAITS]->*(j2:Job))
WHERE j2.status <> "Completed"
WITH process, p2, nodes(p2) AS jobs
WITH process, p2, reduce(duration=0, job in jobs | duration + job.duration * (1-job.completion_progress)) AS total_duration
RETURN process, p2, total_duration
ORDER BY total_duration DESC
LIMIT 1
```