terraform {
  backend "s3" {
    bucket = "my-unique-devops-state-bucket"
    key = "dev/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source             = "../../modules/vpc"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet     = ["10.0.11.0/24", "10.0.12.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source             = "../../modules/eks"
  environment        = "dev"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}
