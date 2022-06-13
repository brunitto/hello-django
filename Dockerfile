# syntax=docker/dockerfile:1
FROM python:3-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /workspaces/hello-django/
COPY core /workspaces/hello-django/core/
COPY main /workspaces/hello-django/main/
COPY manage.py requirements.txt /workspaces/hello-django/
RUN pip install --upgrade pip && pip install -r requirements.txt