module "aws_ha_app" {
  source = "./.."

  environment = var.environment         # dev | prod
  region      = var.region   # used for naming in locals
  project_name = var.project_name

  vpc_id             = var.vpc_id
  public_subnet_ids  = var.public_subnet_ids
  private_subnet_ids = var.private_subnet_ids

  ami_id         = var.ami_id
  instance_type  = var.instance_type # enforced in dev by validation
  app_port       = var.app_port

  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  allowed_ingress_cidrs = var.allowed_ingress_cidrs

  enable_observability = var.enable_observability
  log_retention_days   = var.log_retention_days

  tags = var.tags
}
