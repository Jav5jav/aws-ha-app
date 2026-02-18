locals {
  # Predictable, env-aware naming name_prefix
  name_prefix = "${var.project_name}-${var.environment}-${var.region}"


  common_tags = {
    project     = var.project_name
    environment = var.environment
  }

  tags = merge(local.common_tags, var.tags)

  log_retention_days = coalesce(var.log_retention_days, var.environment == "prod" ? 30 : 7)
  log_group_name     = "${local.name_prefix}-log_group"
}