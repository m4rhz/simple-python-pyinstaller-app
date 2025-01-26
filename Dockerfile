FROM python:3.9-slim

WORKDIR /app

COPY sources/calc.py sources/add2vals.py ./

EXPOSE 8000

CMD ["python", "add2vals.py"]
