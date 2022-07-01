terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "hello_django" {
  name = "hello-django"
  tags = {
    application = var.application_name
    environment = var.environment
  }
}

resource "aws_db_instance" "hello_django" {
  identifier             = "hello-django"
  engine                 = "postgres"
  engine_version         = "13"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  db_name                = "postgres"
  username               = "postgres"
  password               = "postgres"
  port                   = 5432
  publicly_accessible    = true # we need to connect to migrate!
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.default_security_group]
  tags = {
    application = var.application_name
    environment = var.environment
  }
}

resource "aws_iam_role" "app_runner_ecr" {
  name = "AppRunnerECR"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "build.apprunner.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"]
}

resource "aws_iam_role" "app_runner_rds" {
  name = "AppRunnerRDS"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "tasks.apprunner.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonRDSDataFullAccess"]
}

resource "aws_apprunner_vpc_connector" "hello_django" {
  vpc_connector_name = "hello-django"
  subnets            = var.subnets
  security_groups    = [var.default_security_group]
  tags = {
    application = var.application_name
    environment = var.environment
  }
}

resource "aws_apprunner_service" "hello_django" {
  service_name = "hello-django"
  source_configuration {
    auto_deployments_enabled = false
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_ecr.arn
    }
    image_repository {
      image_identifier      = "${aws_ecr_repository.hello_django.repository_url}:development"
      image_repository_type = "ECR"
      image_configuration {
        port          = 8000
        start_command = "python manage.py runserver 0.0.0.0:8000"
        runtime_environment_variables = {
          POSTGRES_HOST     = aws_db_instance.hello_django.address
          POSTGRES_PORT     = aws_db_instance.hello_django.port
          POSTGRES_NAME     = aws_db_instance.hello_django.db_name
          POSTGRES_USER     = aws_db_instance.hello_django.username
          POSTGRES_PASSWORD = aws_db_instance.hello_django.password
          DJANGO_SECRET_KEY = "secret"
          DJANGO_DEBUG      = "False"
        }
      }
    }
  }
  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.hello_django.arn
    }
  }
  instance_configuration {
    instance_role_arn = aws_iam_role.app_runner_rds.arn
  }
  tags = {
    application = var.application_name
    environment = var.environment
  }
}
