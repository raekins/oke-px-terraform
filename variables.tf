variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "compartment_ocid" {
}

variable "region" {
}

variable "ssh_private_key" {
}

variable "ssh_public_key" {
}

variable "kubernetes_version" {
  description = "OKE Kubernetes version"
  type        = string
  default     = "v1.20.11"
}

variable "node_pool_size" {
  description = "number of worker nodes to provision"
  type        = number
  default     = 3
}

variable "pool_name" {
  description = "node pool name"
  type        = string
  default     = "pool"
}

variable "cluster_name" {
  description = "OKE cluster name"
  type        = string
  default     = "cluster"
}

variable "source_ocid" {
  description = "source ocid image"
  type        = string
}

variable "node_pool_boot_volume_size_in_gbs" {
  type	      = number
  default     = 60
}

variable "node_pool_px_volume_size_in_gbs" {
  type        = number
  default     = 100
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  type        = bool
  default     = false
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  type        = bool
  default     = false
}

variable "attachment_type" {
  description = "(Optional) The type of volume. The only supported values are iscsi and paravirtualized."
  type        = string
  default     = "paravirtualized"
}

variable "use_chap" {
  description = "(Applicable when attachment_type=iscsi) Whether to use CHAP authentication for the volume attachment."
  type        = bool
  default     = false
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "APISubnet-CIDR" {
  default = "10.0.0.0/28"
}

variable "NodeSubnet-CIDR" {
  default = "10.0.10.0/24"
}

variable "LBSubnet-CIDR" {
  default = "10.0.20.0/24"
}

variable "VCN-name" {
  default = "vcn"
}

# Bastion Instance
variable "BastionSubnet-CIDR" {
  default = "10.0.30.0/24"
}

variable "bastion_bastion_type" {
  default = "standard"
}

variable "bastion_state" {
  description = "The target state for the instance. Could be set to RUNNING or STOPPED. (Updatable)"
  default     = "RUNNING"
  type        = string
}

# Portworx
variable "px_oper_url" {
  type        = string
}

variable "px_spec_url" {
  type        = string
}
