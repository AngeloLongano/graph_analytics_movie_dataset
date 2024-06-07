## Graph analytics on a Movies datasets

## Preprocessing data
First preprocessing is done by python with pandas on preprocessing.ipynb  
...  
In this file there's also a formatting header and check for data quality to an effecienty import.
It was used neo4j-admin import for importing data to neo4j db because the size of data is very large and classical way is not enough effeciency. All this is also motivated in the [docs](https://neo4j.com/docs/getting-started/data-import/csv-import/#_ways_to_import_csv_files)

## Import data with neo4j-admin
The next steps are based by the documentations [docs](https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin/neo4j-admin-import/#import-tool-full) and [this tutorial](https://neo4j.com/docs/operations-manual/current/tutorial/neo4j-admin-import/)



## Neo4j Graph Analytics
#### Little tips
Drop all index and constraints
```
CALL apoc.schema.assert({},{},true) YIELD label, key
RETURN *
```
Drop data 
```
MATCH (n) DETACH DELETE n;
```

## Cities
The dataset is picked from https://grouplens.org/datasets/movielens/latest/

You can download the datasets [here](https://files.grouplens.org/datasets/movielens/ml-1m.zip)

