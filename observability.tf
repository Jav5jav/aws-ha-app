resource "aws_cloudwatch_log_group" "bootstrap" {
  count             = var.enable_observability ? 1 : 0
  name              = local.log_group_name
  retention_in_days = local.log_retention_days
  tags              = local.common_tags
}

resource "aws_iam_role" "ec2" {
  count = var.enable_observability ? 1 : 0
  name  = "${local.name_prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_instance_profile" "ec2" {
  count = var.enable_observability ? 1 : 0
  name  = "${local.name_prefix}-instance-profile"
  role  = aws_iam_role.ec2[0].name
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  count      = var.enable_observability ? 1 : 0
  role       = aws_iam_role.ec2[0].name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
