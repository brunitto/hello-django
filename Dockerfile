# syntax=docker/dockerfile:1
FROM python:3-bullseye
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

ARG USERNAME=guido
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd --gid ${GROUP_ID} ${USERNAME}
RUN useradd --uid ${USER_ID} --gid ${GROUP_ID} -s /bin/bash -m ${USERNAME}
USER ${USERNAME}

WORKDIR /workspaces/hello-django/
COPY core /workspaces/hello-django/core/
COPY main /workspaces/hello-django/main/
COPY manage.py requirements.txt /workspaces/hello-django/
RUN pip install --upgrade pip && pip install -r requirements.txt
