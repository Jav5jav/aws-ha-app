variable "environment" {
  description = "Deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "region" {
  type        = string
  description = "Name of the region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "ha-app"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
  validation {
    condition     = can(regex("^vpc-[0-9a-fA-F]{8,17}$", var.vpc_id))
    error_message = "vpc_id must be a valid VPC ID"
  }
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnets for ALB (min 2)."
  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "public_subnet_ids must have at least 2 subnets (multi-AZ)."
  }
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnets for ASG instances (min 2)."

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "private_subnet_ids must have at least 2 subnets (multi-AZ)."
  }
}

variable "ami_id" {
  type        = string
  description = "AMI ID. Must be Amazon Linux 2/2023 image"
  validation {
    condition     = can(regex("^ami-[0-9a-fA-F]{8,17}$", var.ami_id))
    error_message = "ami_id must be a valid AMI ID (ex: ami-0abc1234def567890)"
  }
}

variable "instance_type" {
  type        = string
  description = "Instance type of Ec2 machine, Must be t2.micro for dev environment"
  validation {
    condition     = var.environment != "dev" || var.instance_type == "t2.micro"
    error_message = "In dev environment, instance_type must be t2.micro."
  }
  default = "t2.micro"
}

variable "app_port" {
  type        = number
  description = "application port number"
  default     = 8080
}

variable "desired_capacity" {
  type    = number
  default = 2
}
variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "allowed_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs to reach ALB."
  default     = ["70.30.110.37/32"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_observability" {
  type    = bool
  default = true
}

variable "log_retention_days" {
  type    = number
  default = null
}


