# oke-px-terraform
Automated Oracle Kubernetes Engine (OKE) with Portworx deployment using Terraform

## Getting Started

1. Pull Repo
2. Copy terraform.tfvars.example to terraform.tfvars
3. Update terraform.tfvars, providing:
- OCI tennancy details, compartment, compute instance
- OKE cluster details
- Portworx details
4. terraform init
5. terraform validate
6. terraform plan
7. terraform apply --auto-approve

## Authors

Ron Ekins, Principal Solutions Architect, Office of the CTO at Pure Storage

Oracle ACE Director

@ronekins

## Link(s)

Fully automated OKE deployment with Portworx  using Terraform
- (https://ronekins.com/2022/)
