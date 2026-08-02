# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.1.0"
  cloud {
    organization = "REPLACE_ME"
    workspaces {
      name = "gh-actions-demo"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "random_pet" "sg" {}

resource "aws_security_group" "web-sg" {
  name        = "${random_pet.sg.id}-sg"
  description = "Allow inbound HTTP traffic from trusted office network only"

  ingress {
    description = "Allow HTTP from trusted office IP range"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/24"]
  }

  egress {
    description = "Allow outbound HTTPS to trusted internal network only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["203.0.113.0/24"]
  }
}
