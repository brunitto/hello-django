output "application_endpoint" {
  value = aws_apprunner_service.hello_django.service_url
}
