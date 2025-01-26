FROM python:3.9-slim

WORKDIR /app

COPY sources/calc.py sources/add2vals.py ./

# Add a default command that provides some default arguments
CMD ["python", "add2vals.py", "10", "20"]
