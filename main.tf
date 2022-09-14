terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
    backend "s3" {
      dynamodb_table = "sprint6-cr-partyrockers-remote"
      bucket         = "sprint6-cr-partyrockers-remote"
      key            = "network/terraform.tfstate"
      region         = "us-east-2"
    }
  }
  required_version = ">= 1.2.0"
}

###################### PROVIDER INFO ######################

# Here we set the region as well as the default tags
# that will be used on all created resource.

provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}


###################### AWS DATA ######################

# This is data retrieved for the given aws region to
# avoid manually specifying the region as well as the 
# specific availability zones available for a region.

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}