# Build stage
FROM python:3.12-slim AS build

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --prefix=/install -r requirements.txt



# Production stage
FROM python:3.12-slim

WORKDIR /app

COPY --from=build /install /usr/local

COPY . .

RUN useradd -m appuser

USER appuser

EXPOSE 8000

CMD ["python3", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "5320"]
