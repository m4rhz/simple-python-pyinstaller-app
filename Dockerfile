FROM python:3.9-slim

WORKDIR /app

# Create a non-root user
RUN pip install --user -r source/requirements.txt

COPY --chown=myuser:myuser . .

EXPOSE 8000

RUN pip freeze > source/requirements.txt

CMD ["python", "web_app.py"]
