from flask import Flask, request
import pandas as pd
import random
import datetime
import json
from google.cloud import pubsub_v1
import os


# Flask app
app = Flask(__name__)

# Chargement du DataFrame une seule fois au démarrage de la fonction
metadata_df = pd.read_json("processed_data.json", lines=True)
metadata_movie = metadata_df[["movie_id", "runtime"]]

# Variables globales
DEVICES = ["mobile", "tablet", "smart_tv", "desktop"]
LOCATIONS = ["France", "US", "Canada", "Brazil", "India", "Japan", "Germany"]

# Récupère le nom du topic depuis les variables d’environnement
TOPIC_PATH = "projects/movieproject-457013/topics/movie-logs-topic"  # format : projects/PROJECT_ID/topics/TOPIC_NAME

# Client Pub/Sub
publisher = pubsub_v1.PublisherClient()

def generate_log():
    film = metadata_movie.sample(1).iloc[0]
    runtime = int(film["runtime"])
    return {
        "user_id": random.randint(1, 100),
        "video_id": int(film["movie_id"]),
        "watch_time": random.randint(1, max(1, runtime)),
        "device": random.choice(DEVICES),
        "location": random.choice(LOCATIONS),
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z"
    }

@app.route("/", methods=["GET"])
def send_logs():
    for _ in range(10):
        log = generate_log()
        data = json.dumps(log).encode("utf-8")
        publisher.publish(TOPIC_PATH, data=data)
    return "Logs sent to Pub/Sub", 200

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
