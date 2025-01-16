FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libasound2-dev \
    libportaudio2 \
    libatlas-base-dev \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

ENV POCKETSPHINX_PATH=/app/model

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

# flag to verbose logs
CMD ["gunicorn", "-w", "1", "-b", "0.0.0.0:5000", "main:app"]
