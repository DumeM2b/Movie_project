FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
COPY processed-data.json
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "generate_logs.py"]
