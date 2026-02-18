/*

backend "s3" {
  bucket         = "company-terraform-state"
  key            = "ha-vm/dev.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-locks"
  encrypt        = true
}
*/