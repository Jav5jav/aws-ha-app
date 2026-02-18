# ────────────────────────────────────────────────────────────────────────────────
# Security Groups – using dynamic ingress/egress
# ────────────────────────────────────────────────────────────────────────────────

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb-sg" })
}

resource "aws_security_group" "instances" {
  name        = "${var.name_prefix}-instances-sg"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = concat(
      var.instance_ingress_rules,
      # Auto-add rule from ALB SG on app_port
      [{
        from_port       = var.app_port
        to_port         = var.app_port
        protocol        = "tcp"
        security_groups = [aws_security_group.alb.id]
        description     = "Allow traffic from ALB"
      }]
    )
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = lookup(ingress.value, "security_groups", null)
      cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
      description     = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-instances-sg" })
}

# ────────────────────────────────────────────────────────────────────────────────
# ALB
# ────────────────────────────────────────────────────────────────────────────────

resource "aws_lb" "this" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-alb" })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name_prefix}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-tg" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

# ────────────────────────────────────────────────────────────────────────────────
# Launch Template – minimal, no user_data
# ────────────────────────────────────────────────────────────────────────────────

resource "aws_launch_template" "this" {
  name_prefix   = "${var.name_prefix}-"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.instances.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 10
      volume_type = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"

    dynamic "tags" {
      for_each = merge(var.tags, { Name = "${var.name_prefix}-instance" })
      content {
        key   = tags.key
        value = tags.value
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ────────────────────────────────────────────────────────────────────────────────
# Auto Scaling Group – dynamic tags
# ────────────────────────────────────────────────────────────────────────────────

resource "aws_autoscaling_group" "this" {
  name                = "${var.name_prefix}-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.this.arn]

  dynamic "tag" {
    for_each = merge(
      var.tags,
      { Name = "${var.name_prefix}-asg" }
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}