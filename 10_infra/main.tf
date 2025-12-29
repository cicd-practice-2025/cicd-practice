# ---------------------------------------------
# Terraform configuration
# ---------------------------------------------
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "cicd-practice-2025-1204"
    key    = "cicd-practice.tfstate"
    region = "ap-northeast-1"
    #profile = "Terraform-cicd-practice"
  }
}

# ---------------------------------------------
# Provider
# ---------------------------------------------
provider "aws" {
  profile = "Terraform-cicd-practice"
  region  = "ap-northeast-1"
}

# provider "aws" {
#   alias   = "virginia"
#   profile = "terraform"
#   region  = "us-east-1"
# }
