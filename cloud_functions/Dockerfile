FROM python:3.11-slim

WORKDIR /app

# Copier requirements.txt dans /app
COPY requirements.txt .

# Copier processed-data.json dans /app
COPY processed-data.json .

# Installer les dépendances
RUN pip install -r requirements.txt

# Copier tout le reste dans /app
COPY . .

# Lancer le script
CMD ["python", "generate_logs.py"]
