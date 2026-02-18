# AWS HA Ephemeral EC2 Auto Scaling Terraform Module

This Terraform module deploys a **highly available**, **ephemeral** set of Ubuntu EC2 instances in **private subnets** behind a public **Application Load Balancer (ALB)**.

Key features:
- Instances are **private** — no public IP addresses
- All external traffic must route through the ALB
- Ephemeral/stateless design: minimal root volume, no persistent EBS volumes
- Multi-AZ deployment for high availability
- Dynamic security group rules and tags for reusability
- Designed to reach `terraform plan` successfully (no apply required)
- Ubuntu-focused (Canonical AMIs) for consistent behavior

## Usage

```hcl
module "ha_ubuntu_vm" {
  source = "./path/to/module"   # or git::https://github.com/yourusername/terraform-aws-ha-ephemeral-vm.git?ref=v1.0.0

  name_prefix         = "myapp-prod"
  vpc_id              = "vpc-0123456789abcdef0"
  public_subnet_ids   = ["subnet-aaa-public", "subnet-bbb-public"]
  private_subnet_ids  = ["subnet-ccc-private", "subnet-ddd-private"]
  ami_id              = "ami-0abcdef1234567890"   # Official Ubuntu AMI (Canonical owner: 099720109477)
  instance_type       = "t3.micro"
  desired_capacity    = 2
  app_port            = 8080

  tags = {
    Environment = "production"
    Project     = "web-service"
    Owner       = "devops-team"
  }
}
```

## Requirements

| Name       | Version    |
|------------|------------|
| terraform  | >= 1.5.0   |
| aws        | ~> 5.0     |

## Providers

| Name | Version |
|------|---------|
| aws  | 5.x     |

## Resources

| Name                                      | Type     |
|-------------------------------------------|----------|
| aws_security_group.alb                    | resource |
| aws_security_group.instances              | resource |
| aws_lb.this                               | resource |
| aws_lb_target_group.this                  | resource |
| aws_lb_listener.http                      | resource |
| aws_launch_template.this                  | resource |
| aws_autoscaling_group.this                | resource |

## Inputs

| Name                  | Description                                                                 | Type           | Default          | Required |
|-----------------------|-----------------------------------------------------------------------------|----------------|------------------|----------|
| name_prefix           | Prefix for all resource names                                               | string         | "ha-ubuntu"      | no       |
| vpc_id                | VPC ID where resources are deployed                                         | string         | n/a              | yes      |
| public_subnet_ids     | List of public subnet IDs (for ALB) — at least 2                            | list(string)   | n/a              | yes      |
| private_subnet_ids    | List of private subnet IDs (for instances) — at least 2                     | list(string)   | n/a              | yes      |
| ami_id                | Canonical Ubuntu AMI ID (owner 099720109477 recommended)                    | string         | n/a              | yes      |
| instance_type         | EC2 instance type                                                           | string         | "t3.micro"       | no       |
| desired_capacity      | Desired number of instances                                                 | number         | 2                | no       |
| min_size              | Minimum number of instances                                                 | number         | 2                | no       |
| max_size              | Maximum number of instances                                                 | number         | 4                | no       |
| app_port              | Application port that instances listen on                                   | number         | 8080             | no       |
| alb_ingress_rules     | Custom ingress rules for ALB security group (dynamic)                       | list(object)   | [HTTP/80 from anywhere] | no |
| instance_ingress_rules| Custom ingress rules for instance security group (dynamic)                  | list(object)   | []               | no       |
| tags                  | Common tags to apply to all resources                                       | map(string)    | {}               | no       |

## Outputs

| Name            | Description                                      |
|-----------------|--------------------------------------------------|
| alb_dns_name    | DNS name of the public Application Load Balancer |
| asg_name        | Name of the Auto Scaling Group                   |
| target_group_arn| ARN of the target group                          |

## Important Decisions & Compromises

- **Private subnets + no public IP** — Security best practice; no direct internet access to VMs
- **Ephemeral/stateless design** — 10 GiB gp3 root volume only; no additional EBS volumes or persistent storage
- **Dynamic blocks** — Used for security group ingress rules and tag propagation → module is highly reusable/extensible
- **Ubuntu-focused** — Assumes Canonical AMI for consistent apt/cloud-init behavior
- **No observability/logging** — Intentionally omitted to stay focused on core HA + ALB requirements and "terraform plan only" instruction
- **No autoscaling policies** — Manual desired_capacity scaling only; avoids added complexity
- **No HTTPS/WAF/ACM** — Scope control; easy to extend with listener rules
- **No VPC/subnet creation** — Assumes existing VPC + subnets (common in enterprise environments)
- **Time spent** — Approximately X hours (focused on clean code, reusability, and documentation)

## Testing

```bash
# Initialize and format
terraform init
terraform fmt

# Validate
terraform validate

# Plan (replace with your values)
terraform plan \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='public_subnet_ids=["subnet-aaa-public","subnet-bbb-public"]' \
  -var='private_subnet_ids=["subnet-ccc-private","subnet-ddd-private"]' \
  -var="ami_id=ami-0abcdef1234567890"
```

A successful plan confirms the configuration is valid.

## Extending the Module

- Add `user_data` variable for bootstrap (CloudWatch agent, app install, etc.)
- Enable HTTPS listener + ACM certificate
- Add Route 53 alias record for custom domain
- Include autoscaling policies (CPU-based, request count)
- Enable ALB access logs to S3
- Create CloudWatch alarms (high CPU, unhealthy hosts, etc.)
- Support golden AMIs (set `user_data = null`)

## License

MIT
```

Just replace:
- `X hours` with your actual time spent
- GitHub link if you have one
- Any specific AMI example if needed

You can now copy this entire block and paste it into your `README.md` file in one go.  

Good luck with the final touches and the interview tomorrow! You've got this.