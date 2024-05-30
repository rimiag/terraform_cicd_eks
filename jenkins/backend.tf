terraform {
  backend "s3" {
    bucket = "rimaig-bucket"
    key    = "jenkins/terraform/tfstate"
    region = "us-east-1"
  }
}