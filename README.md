# OKE Portworx Terraform
Automated Oracle Kubernetes Engine (OKE) with Portworx deployment using Terraform

## Getting Started

1. Pull this GitRepo
2. Copy terraform.tfvars.example to terraform.tfvars
3. Update terraform.tfvars, providing:
- OCI account, tennancy, compartment, and compute instance image
- OKE cluster details
- Portworx Operator and Specification URL
4. terraform init
5. terraform validate
6. terraform plan
7. terraform apply --auto-approve

## Authors

Ron Ekins, Principal Solutions Architect, Office of the CTO at Pure Storage

Oracle ACE Director

@ronekins

## Link(s)

Oracle Kubernetes Engine
- (https://www.oracle.com/uk/cloud-native/container-engine-kubernetes/)

Portworx
- (https://portworx.com)

Terraform
- (https://www.terraform.io) 

Fully automated OKE deployment with Portworx  using Terraform
- (https://ronekins.com/2022/)
