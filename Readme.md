## Graph analytics on a 


# Drop all index and constraints
"""
CALL apoc.schema.assert({},{},true) YIELD label, key
RETURN *
"""
# Drop data 
"""
MATCH (n) DETACH DELETE n;
"""

docker exec -it neo4j_server /bin/bash

neo4j-admin database import full
--nodes=User=import/users.csv
--nodes=Movie=import/movies.csv \
--relationships import/ratings.csv,import/tags.csv,import/genres.csv \
movies

neo4j-admin database import full --overwrite-destination --id-type=integer --nodes=import/users.csv --nodes=import/movies.csv --nodes=import/genres.csv --relationships=import/ratings.csv --relationships=import/tags.csv --relationships=import/movies_genres.csv movies

# TODO: change files to import

## for permission problem on data dir (probably only wsl users)
"""
sudo chmod -R 777 data
"""
## Cities
The dataset is picked from https://grouplens.org/datasets/movielens/latest/

download the datasets and put on dataset dir "https://files.grouplens.org/datasets/movielens/ml-latest.zip"

