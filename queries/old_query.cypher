// TO DELETE
// MATCH (n) DETACH DELETE n;

// To create constraints

CREATE CONSTRAINT UniqueMovieID IF NOT EXISTS 
FOR (m:Movie) 
REQUIRE m.id IS unique;

CREATE CONSTRAINT UniqueUserID IF NOT EXISTS 
FOR (u:User) 
REQUIRE u.id IS unique;

// Insert nodes

LOAD CSV WITH HEADERS 
    FROM "file:///users.csv" AS row
    MERGE (u:User {id: toInteger(row.userId)})
    SET u.ratings = toInteger(row.ratings),
        u.tags = toInteger(row.tags);

LOAD CSV WITH HEADERS 
    FROM "file:///genres.csv" AS row
    MERGE (g:Genre {id: toInteger(row.genreId)})
    SET g.name = row.name;

LOAD CSV WITH HEADERS 
    FROM "file:///movies.csv" AS row
    MERGE (m:Movie {id: toInteger(row.movieId)})
    SET m.title = row.title,
        m.year = toInteger(row.year);

// Create index 
CREATE INDEX ON :Movie(title);
CREATE INDEX ON :User(name);
CREATE INDEX ON :Genre(name);

CREATE LOOKUP INDEX node_label_lookup IF NOT EXISTS FOR  ON EACH labels(n);
// ...

// Insert relationships
LOAD CSV WITH HEADERS FROM "file:///ratings.csv" AS row
    CALL {
        WITH row
        MATCH (m:Movie {id: toInteger(row.movieId)})
        MATCH (u:User {id: toInteger(row.userId)})
        MERGE (u)-[r:RATED]->(m)
        SET r.rating = toFloat(row.rating),
        r.timestamp = datetime({epochSeconds:toInteger(row.timestamp)})
    } IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///tags.csv" AS row
    CALL {
        WITH row
        MATCH (m:Movie {id: toInteger(row.movieId)})
        MATCH (u:User {id: toInteger(row.userId)})
        MERGE (u)-[t:TAGGED]->(m)
        SET t.tag = row.tag,
        t.timestamp = datetime({epochSeconds:toInteger(row.timestamp)})
    } IN TRANSACTIONS OF 10000 ROWS;

LOAD CSV WITH HEADERS FROM "file:///movies_genres.csv" AS row
    MATCH (m:Movie {id: toInteger(row.movieId)})
    MATCH (g:Genre {id: toInteger(row.genreId)})
    MERGE (m)-[in_g:IN_GENRE]->(g);


CALL apoc.periodic.iterate(
  "MATCH (u:User)-[t:TAGGED]->(m:Movie) RETURN t",
  "SET t.date = datetime({epochSeconds: toInteger(t.timestamp)})",
  {batchSize: 10000, parallel: true}
)
YIELD total, batches, failedBatches, retries, errorMessages
RETURN total, batches, failedBatches, retries, errorMessages;

CALL apoc.periodic.iterate(
  "MATCH (u:User)-[t:TAGGED]->(m:Movie) RETURN t",
  "SET t.date = datetime({epochSeconds: toInteger(t.timestamp)})",
  {batchSize: 10000, parallel: true}
)
YIELD total, batches, failedBatches, retries, errorMessages
RETURN total, batches, failedBatches, retries, errorMessages;