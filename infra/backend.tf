terraform {
  backend "s3" {
    bucket         = "pborade90-terraform-state-bucket"
    key            = "technova/inventory/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "my-terraform-locks"
  }
}
