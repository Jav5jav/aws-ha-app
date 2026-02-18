environment = "dev"          # dev | prod
region      = "us-east-1"     # used for naming in locals
project_name = "ha-app"

vpc_id             = "vpc-0123456789abcdef0"
public_subnet_ids  = ["subnet-aaaa1111", "subnet-bbbb2222"]
private_subnet_ids = ["subnet-cccc3333", "subnet-dddd4444"]

ami_id         = "ami-0abc1234def567890"
instance_type  = "t2.micro"  # enforced in dev by validation
app_port       = 8080

desired_capacity = 2
min_size         = 1
max_size         = 4

allowed_ingress_cidrs = ["203.0.113.10/32"]

enable_observability = true
log_retention_days   = 7

tags = {
    Owner = "platform"
    Cost  = "sandbox"
}