FROM python:3.12-slim

WORKDIR /app

# Install SSL certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .


# Install dependencies
RUN python -m pip install \
    --no-cache-dir \
    --index-url https://pypi.org/simple \
    --timeout=120 \
    --retries=10 \
    -r requirements.txt

# Copy application
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]