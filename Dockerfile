FROM python:3.9-slim

WORKDIR /app

RUN pip install flask

COPY calc.py web_app.py index.html ./

EXPOSE 8000

CMD ["python", "web_app.py"]
