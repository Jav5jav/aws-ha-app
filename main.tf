resource "aws_lb" "app_alb" {
  name               = "${local.name_prefix}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnet_ids
  tags               = local.common_tags
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${local.name_prefix}-tg"
  port     = var.app_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = local.common_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_launch_template" "app_template" {
  name_prefix   = "${local.name_prefix}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" 
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    enable_observability = var.enable_observability
    log_group_name       = local.log_group_name
  })
)

  tag_specifications {
    resource_type = "instance"
    tags          = local.common_tags
  }

  tags = local.common_tags
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "${local.name_prefix}-asg"
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.app_template.id
    version = "$Latest"
  }

}