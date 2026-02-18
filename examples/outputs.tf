output "app_url" {
  description = "Application URL"
  value       = "http://${module.aws_ha_app.alb_dns_name}"
}

output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = module.aws_ha_app.alb_dns_name
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.aws_ha_app.asg_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.aws_ha_app.target_group_arn
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = module.aws_ha_app.launch_template_id
}

output "alb_security_group_id" {
  description = "ALB security group"
  value       = module.aws_ha_app.alb_security_group_id
}

output "app_security_group_id" {
  description = "App instance security group"
  value       = module.aws_ha_app.app_security_group_id
}

output "log_group_name" {
  description = "CloudWatch log group (if enabled)"
  value       = module.aws_ha_app.log_group_name
}

output "instance_profile_name" {
  description = "Instance profile used by EC2"
  value       = module.aws_ha_app.ec2_instance_profile_name
}
