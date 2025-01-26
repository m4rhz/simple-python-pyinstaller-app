FROM python:3.9-slim

WORKDIR /app

# Create a non-root user
RUN useradd -m myuser
USER myuser

COPY --chown=myuser:myuser requirements.txt .
RUN pip install --user -r requirements.txt

COPY --chown=myuser:myuser . .

EXPOSE 8000

CMD ["python", "web_app.py"]
