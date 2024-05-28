import pandas as pd

movies = pd.read_csv("dataset/ml-latest/movies.csv")
ratings = pd.read_csv("dataset/ml-latest/ratings.csv")
tags = pd.read_csv("dataset/ml-latest/tags.csv")

# Users dataset creation
users = ratings["userId"].value_counts().reset_index()
users = users.merge(
    tags["userId"].value_counts().reset_index(), on="userId", how="outer"
)
users.columns = ["userId", "ratings", "tags"]
users = users.fillna(0)
users["tags"] = users["tags"].astype(int)

# Movies dataset year extraction
movies["year"] = movies["title"].str.extract(r"\((\d{4})\)")

# Separate genres from movies
genres = [
    "Action",
    "Adventure",
    "Animation",
    "Children",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Fantasy",
    "Film-Noir",
    "Horror",
    "IMAX",
    "Musical",
    "Mystery",
    "Romance",
    "Sci-Fi",
    "Thriller",
    "War",
    "Western",
    "(no genres listed)",
]

movies["genres"] = movies["genres"].apply(lambda x: x.split("|"))
movies_genres = movies[["movieId", "genres"]].explode("genres")

movies_genres.columns = ["movieId", "genre"]

# Prepare dataset for neo4j-admin import

movies.drop(columns=["genres"], inplace=True)
movies.columns = ["movieId:ID(Movie-ID)", "title", "year:int"]
movies[":LABEL"] = "Movie"

users.columns = ["userId:ID(User-ID)", "ratings:int", "tags:int"]
users[":LABEL"] = "User"

genres = pd.DataFrame(genres, columns=["genre:ID(Genre-ID){id-type:string}"])
genres[":LABEL"] = "Genre"

ratings["timestamp"] = pd.to_datetime(
    ratings["timestamp"], unit="s", utc=True
).dt.strftime("%Y-%m-%dT%H:%M:%S%z")
ratings.columns = [
    "userId:START_ID(User-ID)",
    "movieId:END_ID(Movie-ID)",
    "rating:float",
    "timestamp:datetime",
]
ratings[":TYPE"] = "RATED"

tags["timestamp"] = pd.to_datetime(tags["timestamp"], unit="s", utc=True).dt.strftime(
    "%Y-%m-%dT%H:%M:%S%z"
)

tags.columns = [
    "userId:START_ID(User-ID)",
    "movieId:END_ID(Movie-ID)",
    "tag",
    "timestamp:datetime",
]
tags[":TYPE"] = "TAGGED"

movies_genres.columns = [
    "movieId:START_ID(Movie-ID)",
    "genre:END_ID(Genre-ID){id-type:string}",
]
movies_genres[":TYPE"] = "IN_GENRE"


# Save datasets to csv in docker volume

import os

path_to_save = "data"

if not os.path.exists(path_to_save):
    os.makedirs(path_to_save)

movies.to_csv(f"{path_to_save}/movies.csv", index=False)
users.to_csv(f"{path_to_save}/users.csv", index=False)
genres.to_csv(f"{path_to_save}/genres.csv", index=False)

ratings.to_csv(f"{path_to_save}/ratings.csv", index=False)
tags.to_csv(f"{path_to_save}/tags.csv", index=False)
movies_genres.to_csv(f"{path_to_save}/movies_genres.csv", index=False)
