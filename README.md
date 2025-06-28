📦 Book-Reviews Terraform Infrastructure

📌 Overview

This repository contains Terraform code to provision and manage the cloud infrastructure for the Book-Reviews App.It is responsible for setting up all required AWS resources to support a GitOps-based CI/CD deployment.

⚙️ Infrastructure Components

VPC with public/private subnets

Internet Gateway and NAT Gateway

Route Tables for subnet routing

Security Groups for EC2 and Kubernetes components

EC2 Instances for self-hosted Kubernetes cluster (via kubeadm)

Elastic IPs for NAT and Bastion access

S3 Bucket (optional) for remote backend

Key Pair management for SSH

🛠️ Modules Structure

.
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── security-group/
│   └── ...
├── main.tf
├── variables.tf
├── outputs.tf
└── terraform.tfvars

Each module is reusable and self-contained.

main.tf wires together all modules with specific configurations.

🚀 How to Use

1. Initialize Terraform

terraform init

2. Plan Infrastructure Changes

terraform plan -var-file="terraform.tfvars"

3. Apply Infrastructure

terraform apply -var-file="terraform.tfvars"

💪 Environment Requirements

Terraform CLI >= 1.0

AWS CLI configured with access keys

SSH key pair for EC2 access

Backend setup (optional): S3 + DynamoDB

🔐 Security Considerations

Secrets and sensitive files (e.g., terraform.tfstate) should not be committed.

Use remote backends and IAM policies to protect state files.

Enforce security group checks with tools like Checkov.

🧑‍💻 Related Repositories

🔧 Book-Reviews App — Source code

🚀 book-reviews-gitops — GitOps deployment & K8s manifests
