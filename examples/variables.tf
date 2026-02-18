variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "app_port" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "allowed_ingress_cidrs" {
  type = list(string)
}

variable "enable_observability" {
  type = bool
}

variable "log_retention_days" {
  type = number
}

variable "tags" {
  type = map(string)
}

