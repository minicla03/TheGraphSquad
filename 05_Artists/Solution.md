# Artists

## Challenge 1

> [!NOTE] Assignment
> List **the names of artists who participate in shows held in Genoa and have at least 5 years of experience**.

```cypher
MATCH (a:Artista)-[:PARTECIPA_A]->(:Spettacolo)-[:SI_TIENE_IN]->(:Luogo {paese: "Genova"})
WHERE a.anni >= 5
RETURN DISTINCT a.nome AS artist_name, a.anni AS experience_years
ORDER BY experience_years DESC
```

## Challenge 2

> [!NOTE] Assignment
> List **all artists who use the "Trapezio Volante"**.

```cypher
MATCH (a:Artista)-[:UTILIZZA_EQUIPAGGIAMENTO]->(:Equipaggiamento {nome: "Trapezio Volante"})
RETURN a.nome
```

## Challenge 3

> [!NOTE] Assignment
> Find **all pairs of artists who are connected by a direct or indirect friendship** through a mutual friend (i.e., direct
> friends or friends of friends).  
> Avoid reporting duplicate pairs, e.g., Mario, Anna, and Anna, Mario.

```cypher
MATCH (a1:Artista)-[:AMICO_DI*1..2]-(a2:Artista)
WHERE elementId(a1) < elementId(a2)
RETURN DISTINCT a1.nome, a2.nome
```

Alternatively, it is possible to show the direct and indirect friends of an artist using a list:

```cypher
MATCH (a1:Artista)-[:AMICO_DI*1..2]-(a2:Artista)
WHERE elementId(a1) < elementId(a2)
RETURN DISTINCT a1.nome, collect(a2.nome) AS friends
```

## Challenge 4

> [!NOTE] Assignment
> Find **pairs of artist friends who also worked in the same show**.  
> Return artist names and the show.

```cypher
MATCH
  (a1:Artista)-[:AMICO_DI]->(a2:Artista),
  (a1)-[:PARTECIPA_A]->(s:Spettacolo)<-[:PARTECIPA_A]-(a2)
RETURN a1.nome, a2.nome, s.nome
```

An alternative solution can be the following one:

```cypher
MATCH (a1:Artista)-[:PARTECIPA_A]->(s:Spettacolo)<-[:PARTECIPA_A]-(a2:Artista)
WHERE elementId(a1) < elementId(a2) AND (a1)-[:AMICO_DI]-(a2)
RETURN a1.nome, a2.nome, s.nome
ORDER BY a1.nome ASC
```

## Challenge 5

> [!NOTE] Assignment
> Find a chain of relationships: **who is friends with someone attending a show in Turin**?

```cypher
MATCH p=((a:Artista)-[:AMICO_DI]->(friend:Artista)-[:PARTECIPA_A]->(s:Spettacolo)-[:SI_TIENE_IN]->(:Luogo{paese: 'Torino'}))
RETURN p
```

## Challenge 6

> [!NOTE] Assignment
> List **artists who share the same equipment with others but are not friends**.

```cypher
MATCH (a1:Artista)-[:UTILIZZA_EQUIPAGGIAMENTO]->(e:Equipaggiamento)<-[:UTILIZZA_EQUIPAGGIAMENTO]-(a2:Artista)
WHERE NOT (a1)-[:AMICO_DI]-(a2)
AND elementId(a1) < elementId(a2)
RETURN a1.nome, a2.nome, e.nome
```

## Challenge 7

> [!NOTE] Assignment
> Find **the shortest friendship chain that can connect "Sergio il Mimo" and "Leo il Domatore"**.

```cypher
MATCH p = shortestPath((:Artista {nome: "Sergio il Mimo"})-[*]-(:Artista {nome: "Leo il Domatore"}))
RETURN p
```