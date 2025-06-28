# 📦 Book-Reviews Terraform Infrastructure

## 📌 Overview

This repository contains Terraform code to provision and manage the cloud infrastructure for the Book-Reviews App.It is responsible for setting up all required AWS resources to support a GitOps-based CI/CD deployment.

## ⚙️ Infrastructure Components

VPC with public/private subnets

Internet Gateway and NAT Gateway

Route Tables for subnet routing

Security Groups for EC2 and Kubernetes components

EC2 Instances for self-hosted Kubernetes cluster (via kubeadm)

Elastic IPs for NAT and Bastion access



## 🚀 How to Use

1. Initialize Terraform

terraform init

2. Plan Infrastructure Changes

terraform plan -var-file="terraform.tfvars"

3. Apply Infrastructure

terraform apply -var-file="terraform.tfvars"

## 💪 Environment Requirements

Terraform CLI >= 1.0

AWS CLI configured with access keys

SSH key pair for EC2 access


## 🔗 Source Code Repository
- 📁 [Book-Reviews](https://github.com/nnhaiNam/Book-Reviews.git)  
    _Contains the full source code of the application._
  

## 🔗 GitOps Repository
- 📁 [book-reviews-gitops](https://github.com/nnhaiNam/book-reviews-gitops.git)  
    _Contains K8s manifests, Ingress, Argo CD configs and Slack alert rules for GitOps deployment._


