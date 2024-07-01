# Graph analytics on a Movies datasets

In this project, Graph analytics was performed on a [group lens](https://grouplens.org) dataset of movie reviews.  
The workflow of project is:
- Preprocessing and prepare data to import in a Neo4j server [0_preprocessing](0_preprocessing.ipynb)
- Import data with neo4j-admin [1_import](1_import.ipynb) (or classical way [1_classical_import](1_classical_import.ipynb))
- Explore data, analyze graph structure and add some information on graph [2_exploratory_analysis](2_exploratory_analysis.ipynb)
- Create a Recommendation Systems from a similarity analysis and a Community Detection Analysis [3_research_questions](3_research_questions.ipynb)

## Technical information
Docker was used in the project and the steps to configure and use it are indicated in the notebook. For more information look in the [documentation](https://docs.docker.com/get-docker/).

The python libraries were used:
- pandas
- numpy
- scipy
- matplotlib
- neo4j
- graphdatascience

## Cities
The dataset is picked from [GroupLens.org](https://grouplens.org/datasets/movielens/1m/)

You can download the datasets [here](https://files.grouplens.org/datasets/movielens/ml-1m.zip)

This project is also available on [github](https://github.com/AngeloLongano/graph_analytics_movie_dataset). 


