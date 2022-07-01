variable "vpc" {
  type    = string
  default = "vpc-06276086ee72eca00"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-022b37c187c2d0817", "subnet-056b036d817e5b9c0"]
}

variable "default_security_group" {
  type    = string
  default = "sg-029cb8a3b93f35fa5"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "application_name" {
  type    = string
  default = "hello-django"
}
