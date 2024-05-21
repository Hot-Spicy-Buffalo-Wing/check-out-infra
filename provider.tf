terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "aws_profile" {
  type    = string
  default = "default"
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = var.aws_profile
}

