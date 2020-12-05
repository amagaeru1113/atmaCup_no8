FROM python:3.8-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /work

COPY poetry.lock pyproject.toml ./

RUN pip install poetry

RUN poetry config virtualenvs.create false \
    && poetry install
