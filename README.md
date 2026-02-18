# aws-ha-app (feature-app) — HA ALB + ASG (Ephemeral EC2) Terraform Module

This module provisions a **highly-available** web entrypoint using a **public Application Load Balancer** in **public subnets** and an **Auto Scaling Group** of **ephemeral EC2 instances** in **private subnets**. Instances are intended to be disposable/stateless.

## What it builds

- **ALB (public)** listening on **HTTP :80**
- **Target Group (HTTP)** forwarding to instances on `var.app_port` (default `8080`)
- **Auto Scaling Group** across **>= 2 private subnets** (multi-AZ)
- **Launch Template** with **IMDSv2 enforced**
- **Security Groups**
  - ALB SG: inbound `:80` from `allowed_ingress_cidrs`
  - App SG: inbound `app_port` **only from ALB SG**
- Optional **CloudWatch Log Group + IAM role/profile** when `enable_observability=true`

## Assumptions

- VPC + subnets already exist (this module is “app edge + compute”, not networking)
- ALB subnets are **public**, ASG subnets are **private**
- Instances are **ephemeral/stateless** (no additional data volumes)
- HTTP-only (no ACM/HTTPS/WAF in scope)

## Usage

```hcl
module "aws_ha_app" {
  source = "git::https://github.com/Jav5jav/aws-ha-app.git?ref=feature-app"

  environment = "dev"          # dev | prod
  region      = "us-east-1"     # used for naming in locals
  project_name = "ha-app"

  vpc_id             = "vpc-0123456789abcdef0"
  public_subnet_ids  = ["subnet-aaaa1111", "subnet-bbbb2222"]
  private_subnet_ids = ["subnet-cccc3333", "subnet-dddd4444"]

  ami_id         = "ami-0abc1234def567890"
  instance_type  = "t2.micro"  # enforced in dev by validation
  app_port       = 8080

  desired_capacity = 2
  min_size         = 1
  max_size         = 4

  allowed_ingress_cidrs = ["203.0.113.10/32"]

  enable_observability = true
  log_retention_days   = 7

  tags = {
    Owner = "platform"
    Cost  = "sandbox"
  }
}

