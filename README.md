# HELLO-DJANGO

A simple web application written in Django.

# Development environment

This project uses Docker + VS Code Development Containers feature to provide a
consistent and easy to use development environment.

## Requirements

1. Python 3
2. Django 4
3. PostgreSQL 13
4. Docker 20
5. VS Code + Remote Containers extension

## Initial setup

Open in VS Code:

    cd /path/to/hello-django
    code .

This will detect the development container configuration within `.devcontainer`
directory and start the development environment, using the
`docker-compose.yaml` and `Dockerfile` files.

Run an application check:

    python manage.py check

This will check if there are any configuration problem.

The output should be something like:

    System check identified no issues (0 silenced).

Run the application's migrations:

    python manage.py migrate

This will create the necessary database tables.

## Tests

Run the tests

    python manage.py test

Run the tests under coverage:

    coverage run --include 'main/*' manage.py test

Check the coverage report:

    coverage report --show-missing

This will ensure that are no code without tests.

## Development server

Run the development server:

    python manage.py runserver

This will start a simple development server within the container, available at:
http://localhost:8000

If you want to test using gunicorn:

    gunicorn -w 2 core.wsgi

This will start a production-ready development server within the container,
also available at: http://localhost:8000

## Development workflow

Start from branch `main`:

    git checkout main
    git pull origin main

Create branch `development` from `main`:

    git checkout -b development

Note: if the branch `development` exists, just checkout:

    git checkout development

Add / commit / push:

    git add ...
    git commit ...
    git push ...

This will ensure that stable code is in `main` branch and `unstable` code is in
`development` branch.

# Continuous integration (CI)

This project's continuous integration uses GitHub Actions and is configured in
the `.github/workflows/ci.yaml` file.

Commit and push to the `development` branch to start the CI.

# Production environment

## Requirements

1. Python 3
2. Django 4
3. PostgreSQL 13
4. Terraform 1
5. GitHub Actions
6. AWS ECR / AppRunner / RDS PostgreSQL

## Infrastructure provisioning

Export AWS credentials environment variables:

    export AWS_ACCESS_KEY_ID="..."
    export AWS_SECRET_ACCESS_KEY="..."

Initialize Terraform:

    cd terraform
    terraform init

This will create the Terraform configuration and state.

Plan:

    terraform plan

This will check the Terraform modules and AWS resources, and create a plan to
provision the required resources.

Apply:

    terraform apply

This will provision the required resources in AWS.

## Continuous deployment (CD)

This project's continuous deployment uses GitHub Actions and is configured in
the `.github/workflows/cd.yaml` file.

Create a new release in GitHub to start the CD.
