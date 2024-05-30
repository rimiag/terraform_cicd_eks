terraform {
  backend "s3" {
    bucket = "rimaig-bucket"
    key    = "eks_cluster/terraform.tfstat"
    region = "us-east-1"
  }
}