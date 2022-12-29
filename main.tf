provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-up-running"
    key            = "circleci/dev.tfstate"
    dynamodb_table = "s3-state-lock"
    region         = "us-east-1"
    encrypt        = true
  }
}


locals {
  name   = "vpc-circleci"
  region = "us-east-1"
  tags = {
    Environment = "circleci",
    Product     = "VPC",
    terraform   = "true"
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  create_igw           = true

  public_subnet_tags = {
    "Name" = "pub-${local.name}-subnets"
  }

  private_subnet_tags = {
    "Name" = "priv-${local.name}-subnets"
  }

  tags = local.tags
}