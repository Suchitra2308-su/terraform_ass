terraform {
  backend "s3" {
    bucket = "vikaskarbail12346"
    region = "us-east-1"
    key    = "terraform/terraform"
  }
}
