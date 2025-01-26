FROM python:3.9-slim

WORKDIR /app

# Expose port
EXPOSE 8000

# Run the application
CMD ["python -m PyInstaller", "sources/add2vals.py"]
