
# Observability (optional)


output "log_group_name" {
  description = "CloudWatch log group name used for bootstrap/app logs (null if observability disabled)"
  value       = var.enable_observability ? local.log_group_name : null
}

output "ec2_instance_profile_name" {
  description = "EC2 instance profile used by EC2 instances (null if observability disabled)"
  value       = try(aws_iam_instance_profile.ec2[0].name, null)
}


# Core infrastructure


output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = aws_lb.app_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.app_alb.arn
}

output "listener_http_arn" {
  description = "ARN of the HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app_tg.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.app_template.id
}


# Security groups (integration)


output "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  value       = aws_security_group.alb_sg.id
}

output "app_security_group_id" {
  description = "Security group ID attached to EC2 instances"
  value       = aws_security_group.app_sg.id
}
