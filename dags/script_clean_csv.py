import pandas as pd
import ast

def clean_and_save_to_gcs(gcs_movies, gcs_credits, gcs_output_json):
    data_movie = pd.read_csv(gcs_movies, storage_options={"token": "cloud"})
    data_credit = pd.read_csv(gcs_credits, storage_options={"token": "cloud"})

    def extraire_noms(colonne, champ):
        def extract_from_string(val):
            try:
                lst = ast.literal_eval(val)
                return [item[champ] for item in lst]
            except:
                return []
        return colonne.apply(extract_from_string)

    data_movie["keywords"] = extraire_noms(data_movie["keywords"], "name")
    data_movie["genres"] = extraire_noms(data_movie["genres"], "name")
    data_movie["production_companies"] = extraire_noms(data_movie["production_companies"], "name")
    data_movie["production_countries"] = extraire_noms(data_movie["production_countries"], "name")
    data_movie["spoken_languages_name"] = extraire_noms(data_movie["spoken_languages"], "name")
    data_movie["spoken_languages_iso"] = extraire_noms(data_movie["spoken_languages"], "iso_639_1")

    data_credit["cast"] = extraire_noms(data_credit["cast"], "name")
    data_credit["crew"] = extraire_noms(data_credit["crew"], "name")

    for col in ["homepage", "original_language", "original_title", "overview", "tagline", "title", "status"]:
        data_movie[col] = data_movie[col].astype(str)

    data = pd.merge(data_movie, data_credit, left_on="id", right_on="movie_id", how='inner')
    data.drop(columns=['id', 'title_y', 'spoken_languages'], inplace=True)
    data.rename(columns={'title_x': 'title'}, inplace=True)
    data = data.replace('nan', '', regex=True)
    data = data[(data["runtime"].notnull()) & (data["release_date"].notnull()) & (data["runtime"] != 0)]

    # Export en JSONL vers GCS
    data.to_json(
        gcs_output_json,
        orient="records",
        lines=True,
        force_ascii=False,
        storage_options={"token": "cloud"}
    )
