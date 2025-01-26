FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Install system dependencies and PyInstaller
RUN apt-get update && apt-get install -y \
    build-essential \
    && pip install --no-cache-dir pyinstaller \
    && apt-get clean

# Copy your application code to the container
COPY sources/ ./sources/

# Build the executable using PyInstaller
RUN pyinstaller --onefile sources/add2vals.py

# Expose the desired port
EXPOSE 8000

# Set the CMD to run the generated executable
CMD ["./dist/add2vals", "3", "5"]
