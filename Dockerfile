FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy all source files
COPY sources/ .

# Install Flask
RUN pip install --no-cache-dir flask

# Expose port
EXPOSE 8000

# Run the application
CMD ["python", "web_app.py"]
