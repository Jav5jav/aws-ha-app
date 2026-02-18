output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "Public DNS name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}