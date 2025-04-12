terraform {


  required_version = "~> 1.7, < 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}
