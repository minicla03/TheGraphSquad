# Clients & Products: KNN-Based Recommendation System

## Optional Challenge
The final page of the exercise tells about an optional challenge, which consists in changing the parameters for the
KNN algorithm and the user which the system has to generate recommendations for.

The solution consists in the following two queries:

```cypher
CALL gds.knn.write(
	'purchases',
	{
	    nodeProperties: ['embedding'],
	    nodeLabels: ['Product'],  // Calcolo della similarità solamente tra prodotti
	    topK: 2,
	    sampleRate: 1.0,
	    deltaThreshold: 0.0,
	    randomSeed: 42,
	    concurrency: 1,
	    writeProperty: 'score',
	    writeRelationshipType: 'SIMILAR'
	}
)
YIELD similarityDistribution
RETURN similarityDistribution.mean AS meanSimilarity
```

```cypher
MATCH (customer:Person {name: 'Dan'})-[:BUYS]->(bought:Product)
MATCH (bought)-[sim:SIMILAR]->(recommended:Product)
WHERE NOT EXISTS { (customer)-[:BUYS]->(recommended) }
RETURN DISTINCT recommended.name AS recommendation, sim.score AS similarity
ORDER BY similarity DESC
```