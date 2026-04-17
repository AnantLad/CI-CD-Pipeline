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

  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet      = var.public_subnet
  private_subnet     = var.private_subnet
  availability_zones = var.availability_zones
}

module "eks" {
  source             = "../../modules/eks"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "security" {
  
  source = "./modules/security"
  project_name = var.project_name
  vpc_id = module.vpc.vpc_id
}