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
6. Terraform 1

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

    python -m coverage run --include 'main/*' manage.py test

Check the coverage report:

    python -m coverage report --show-missing

This will ensure that are no code without tests.

## Development server

Run the development server:

    python manage.py runserver

This will start a simple development server within the container, available at:
http://localhost:8000

## Development workflow

To use git within the development container, it's necessary to start a SSH
agent and add your keys, so the extension will forward the agent to the
development container:

    ssh-agent
    ssh-add

More information available at:
https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys

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

The CI workflow depends on a previous configuration, including creating an IAM
user / policies to allow GitHub Actions to login, push and pull images from
ECR.

Yet, the CI workflow also depends on an existing ECR repository, that should
be provisioned using Terraform:

    terraform plan -target aws_ecr_repository.hello_django
    terraform apply -target aws_ecr_repository.hello_django

# Production environment

## Requirements

1. Python 3
2. Django 4
3. PostgreSQL 13
4. Terraform 1
5. GitHub Actions
6. AWS ECR / AppRunner / RDS

## Infrastructure provisioning

This project uses Terraform to provision application-specific resources in AWS.
The provisioning depends on existing resources, including a VPC, subnets,
security groups (the default AWS setup works).

Initialize Terraform:

    terraform init

This will create the Terraform configuration and state.

Plan:

    terraform plan

This will check the Terraform modules and AWS resources, and create a plan to
provision the required resources.

Apply:

    terraform apply

This will provision the required resources in AWS.

Note: you will need to specify the database password. Use a strong password and
save it in a reliable password manager.

## Continuous deployment (CD)

This project's continuous deployment uses GitHub Actions and is configured in
the `.github/workflows/cd.yaml` file.

Create a new release in GitHub to start the CD.

The CD workflow depends on a previous configuration, including creating an IAM
user / policies to allow GitHub Actions to login, push and pull images from
ECR.
