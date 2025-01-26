FROM python:3.9-slim

WORKDIR /app

# Install dependencies
RUN pip install flask

# Copy entire sources directory
COPY sources/ .

# Create templates directory and move HTML
RUN mkdir -p templates
RUN mv index.html templates/

# Expose port
EXPOSE 8000

# Run the application
CMD ["python", "web_app.py"]
