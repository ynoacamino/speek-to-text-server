FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py ./

EXPOSE 5000

CMD ["flask", "--app", "main", "run", "--host", "0.0.0.0"]
