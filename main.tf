terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"  # Update with your desired region
  access_key = "AKIAVBG53YQM36JT3TOD"
  secret_key = "VB1f7v4MKtsP66FGjqu531zpPvqSse80KYomXkMB"
}

# IAM role for EC2 instance
resource "aws_iam_role" "vault_instance_role" {
  name               = "vault-instance-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# IAM policy for the EC2 instance role
resource "aws_iam_policy" "vault_instance_policy" {
  name        = "vault-instance-policy"
  description = "Policy for EC2 instance to assume the role configured in Vault"
  
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "arn:aws:iam::346210157593:role/<vault_role_name>"  # Update with your Vault role ARN
      }
    ]
  })
}

# Attach policy to IAM role
resource "aws_iam_role_policy_attachment" "vault_instance_policy_attachment" {
  role       = aws_iam_role.vault_instance_role.name
  policy_arn = aws_iam_policy.vault_instance_policy.arn
}
# SSH Key Pair
resource "tls_private_key" "vault_instance_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to a file
resource "local_file" "vault_instance_ssh_private_key" {
  sensitive_content = tls_private_key.vault_instance_ssh_key.private_key_pem
  filename          = "${path.module}/vault_instance_ssh_private_key.pem"
}
# EC2 instance
resource "aws_instance" "vault_instance" {
  ami                    = "ami-080e1f13689e07408"  # Update with your desired AMI
  instance_type          = "t2.micro"  # Update with your desired instance type
  iam_instance_profile   = aws_iam_role.vault_instance_role.name
  subnet_id              = "subnet-12345678"  # Update with your desired subnet ID
  vpc_security_group_ids = ["sg-12345678"]  # Update with your desired security group IDs

  tags = {
    Name = "vault-instance"
  }
}
