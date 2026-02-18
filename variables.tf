variable "alb_name" {
  description = "VPC ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be dev or prod."
  }
}

variable "instance_types" {
  description = "Instance types requested by caller"
  type        = list(string)
}

------

variable "name_prefix" {
  type    = string
  default = "ha-ubuntu"
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "At least 2 private subnets required for HA."
  }
}

variable "public_subnet_ids" {
  type = list(string)
  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "At least 2 public subnets required for public ALB."
  }
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "alb_ingress_rules" {
  description = "Custom ingress rules for ALB SG"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP from anywhere"
    }
  ]
}

variable "instance_ingress_rules" {
  description = "Custom ingress rules for instance SG (from ALB)"
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
    description     = optional(string)
  }))
  default = []   # will be filled dynamically from ALB SG
}

variable "tags" {
  type    = map(string)
  default = {}
}