terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
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