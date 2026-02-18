locals {
  # --------
  # Identity
  # --------
  project     = var.project
  environment = var.environment
  region      = var.aws_region

  # Predictable, env-aware naming prefix
  prefix = "${local.project}-${local.environment}-${local.region}"

  # ------------
  # Common tags
  # ------------
  common_tags = {
    Project     = local.project
    Environment = local.environment
    ManagedBy   = "terraform"
  }

  # -----------------------
  # User data (separate file)
  # -----------------------
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    environment    = local.environment
    log_group_name = var.log_group_name
  })
}