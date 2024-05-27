// TO DELETE
// MATCH (n) DETACH DELETE n;

// To create consytaints

CREATE CONSTRAINT UniqueMovieID IF NOT EXISTS 
FOR (m:Movie) 
REQUIRE m.id IS unique;

CREATE CONSTRAINT UniqueUserID IF NOT EXISTS 
FOR (u:User) 
REQUIRE u.id IS unique;

// Insert nodes

LOAD CSV WITH HEADERS 
FROM "file:///users.csv" AS row
MERGE (u:User {id: toInteger(row.userId)});

LOAD CSV WITH HEADERS 
FROM "file:///movies.csv" AS row
MERGE (m:Movie {id: toInteger(row.movieId)})
SET m.title = row.title,
    m.genres = split(row.genres, '|');

// Create index 


// Insert relationships
LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS row
MATCH (m:Movie {id: toInteger(row.movieId)})
MATCH (u:User {id: toInteger(row.userId)})
MERGE (u)-[r:RATED]->(u)
SET r.rating = toFloat(row.rating);

LOAD CSV WITH HEADERS FROM "file:///tags.csv" AS row
MATCH (m:Movie {id: toInteger(row.movieId)})
MATCH (u:User {id: toInteger(row.userId)})
MERGE (u)-[t:TAGGED]->(u)
SET t.rating = row.tag;