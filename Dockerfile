FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py ./

EXPOSE 5000

CMD ["flask", "--app", "main", "run", "--host", "0.0.0.0"]
