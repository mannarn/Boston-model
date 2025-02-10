FROM python:3.8-slim

WORKDIR /app

# Copy files from the build context (repository root) into the container
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY train.py .

ENTRYPOINT ["python", "train.py"]
