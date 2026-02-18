output "log_group_name" {
  description = "CloudWatch log group name used for bootstrap/app logs (null if observability disabled)."
  value       = var.enable_observability ? local.log_group_name : null
}

output "ec2_instance_profile_name" {
  description = "EC2 instance profile name used for CloudWatch agent (null if observability disabled)."
  value       = try(aws_iam_instance_profile.ec2[0].name, null)
}

output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "Name of the Auto Scaling Group"
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer."
  value       = aws_lb.app_alb.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.app_alb.arn
}

output "listener_http_arn" {
  description = "ARN of the HTTP (port 80) listener."
  value       = aws_lb_listener.http.arn
}

output "target_group_arn" {
  description = "ARN of the target group behind the ALB."
  value       = aws_lb_target_group.app_tg.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group."
  value       = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  description = "ID of the EC2 launch template used by the ASG."
  value       = aws_launch_template.app_template.id
}

output "alb_security_group_id" {
  description = "Security group ID attached to the ALB."
  value       = aws_security_group.alb_sg.id
}

output "app_security_group_id" {
  description = "Security group ID attached to the EC2 instances."
  value       = aws_security_group.app_sg.id
}
