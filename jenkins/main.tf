# VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "bt-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.azs.names
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  tags = {
    Name        = "Jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "jenkin_server_subnet"
  }

}

# SG
# creating a security group
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins_server_sg"
  description = "Jenkins server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }

  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"

    }
  ]
  tags = {
    Name = "jenkin_server-sg"
  }
}
# EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  ami  =   var.ami
  name = "Dev_Jenkins_server"

  instance_type               = var.instance_type
  key_name                    = "Devops_key_pairs"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins_user_data.sh")
  availability_zone           = data.aws_availability_zones.azs.names[0]

  tags = {
    Name        = "Dev_Jenkins_Server"
    Terraform   = "true"
    Environment = "dev"
  }
}