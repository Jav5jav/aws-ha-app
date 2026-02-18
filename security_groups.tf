# SG for the app.

resource "aws_security_group" "alb_sg" {
  name        = "${local.name_prefix}-alb-sg"
  description = "ALB ingress"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ingress_cidrs
  }

  egress {
    description     = "To app ec2 instances"
    from_port       = 0
    to_port         = 0
    protocol        = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags        = local.common_tags
}

resource "aws_security_group" "app_sg" {
  name        = "${local.name_prefix}-instances-sg"
  description = "Instances only accept traffic from ALB"
  vpc_id      = var.vpc_id
 

  ingress {
    description     = "App traffic from ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Outbound (tighten in prod via VPC endpoints/NAT controls)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags        = local.common_tags
}