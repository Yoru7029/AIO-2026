FROM python:3.12-slim

WORKDIR /app

RUN pip install numpy
RUN pip install matplotlib

COPY main.py .

CMD ["python", "main.py"]
