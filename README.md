# OKE Portworx Terraform
Automated Oracle Cloud Infrastructure (OCI) Oracle Kubernetes Engine (OKE) with Portworx deployment using Terraform

## Getting Started

The Terraform script creates a Kubernetes coniguration file in `.kube/config` (see kubeconfig.tf)
To have direct desktop access using kubectl add this location to your KUBECONFIG, for example:

`export KUBECONFIG=${KUBECONFIG}:/Users/rekins/myTerraform/oke-px-terrafom/.kube/config`

1. Pull this GitRepo
2. Copy terraform.tfvars.example to terraform.tfvars
3. Update terraform.tfvars, providing:
- OCI account details, tennancy, compartment, and compute instance image
- OKE cluster details
- Portworx Operator and specification URL
4. Deploy OKE enviroment, using:
```
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
```
### Author

- **Ron Ekins, Principal Solutions Architect, Office of the CTO at Pure Storage**
- Oracle ACE Director
- [@ronekins](https://www/twitter.com/ronekins)

### Useful Link(s)

- [Oracle Cloud Infrastructure Oracle Kubernetes Engine](https://www.oracle.com/uk/cloud-native/container-engine-kubernetes/)
- [Portworx](https://portworx.com)
- [Terraform](https://www.terraform.io) 
- [Fully automated OKE deployment with Portworx using Terraform](https://ronekins.com/2022/)
- [Getting started with Oracle database Kubernetes Operator](https://ronekins.com/2021/11/11/getting-started-with-the-oracle-database-kubernetes-operator-part-1)
