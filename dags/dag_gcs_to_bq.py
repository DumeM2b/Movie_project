from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.operators.dummy_operator import DummyOperator
import datetime

from script_clean_csv import clean_and_save_to_gcs  

default_args = {
    'owner': 'airflow',
    'start_date': datetime.datetime.today(),
    'depends_on_past': False,
    'email': [''],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': datetime.timedelta(minutes=5),
}

with DAG('etl_full_gcs',
         schedule_interval=None,
         default_args=default_args,
         catchup=False,
         tags=['etl', 'gcs', 'bigquery']) as dag:

    # Définir une tâche de démarrage (Start)
    start_task = DummyOperator(
        task_id='start_etl'
    )

    # Tâche de nettoyage des fichiers (étape 1)
    clean_task = PythonOperator(
        task_id='clean_gcs_files',
        python_callable=clean_and_save_to_gcs,
        op_kwargs={
            'gcs_movies': 'gs://movie-data-etl-bucket/raw/tmdb_5000_movies.csv',
            'gcs_credits': 'gs://movie-data-etl-bucket/raw/tmdb_5000_credits.csv',
            'gcs_output_json': 'gs://movie-data-etl-bucket/clean/cleaned_movies.json'  
        }
    )

    # Tâche de chargement dans BigQuery (étape 2)
    load_to_bq = GCSToBigQueryOperator(
        task_id='load_to_bigquery',
        bucket='movie-data-etl-bucket',
        source_objects=['clean/cleaned_movies.json'],
        destination_project_dataset_table='movieproject-457013.movie.metadata_movie',
        schema_fields=[ 
            {"name": "movie_id", "type": "INT64", "mode": "NULLABLE"},
            {"name": "budget", "type": "INT64", "mode": "NULLABLE"},
            {"name": "genres", "type": "STRING", "mode": "REPEATED"},
            {"name": "homepage", "type": "STRING"},
            {"name": "keywords", "type": "STRING", "mode": "REPEATED"},
            {"name": "original_language", "type": "STRING"},
            {"name": "original_title", "type": "STRING"},
            {"name": "overview", "type": "STRING"},
            {"name": "popularity", "type": "FLOAT64"},
            {"name": "production_companies", "type": "STRING", "mode": "REPEATED"},
            {"name": "production_countries", "type": "STRING", "mode": "REPEATED"},
            {"name": "release_date", "type": "DATE"},
            {"name": "revenue", "type": "INT64"},
            {"name": "runtime", "type": "FLOAT64"},
            {"name": "spoken_languages_name", "type": "STRING", "mode": "REPEATED"},
            {"name": "status", "type": "STRING"},
            {"name": "tagline", "type": "STRING"},
            {"name": "title", "type": "STRING"},
            {"name": "vote_average", "type": "FLOAT64"},
            {"name": "vote_count", "type": "INT64"},
            {"name": "spoken_languages_iso", "type": "STRING", "mode": "REPEATED"},
            {"name": "cast", "type": "STRING", "mode": "REPEATED"},
            {"name": "crew", "type": "STRING", "mode": "REPEATED"},
        ],
        source_format='NEWLINE_DELIMITED_JSON',  # Format JSONL
        skip_leading_rows=1,
        write_disposition='WRITE_TRUNCATE'
    )

    # Définir une tâche de fin (End)
    end_task = DummyOperator(
        task_id='end_etl'
    )

    # Définir l'ordre des tâches
    start_task >> clean_task >> load_to_bq >> end_task