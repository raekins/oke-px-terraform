# VCN
resource "oci_core_vcn" "px_oci_core_vcn" {
  cidr_block     = var.VCN-CIDR 
  compartment_id = var.compartment_ocid
  display_name   = var.VCN-name
  dns_label      = var.cluster_name
}

# Internet Gateway
resource "oci_core_internet_gateway" "px_oci_core_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "px-igw"
  enabled        = "true"
  vcn_id         = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Nat Gateway
resource "oci_core_nat_gateway" "px_oci_core_nat_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "px-ngw"
  vcn_id         = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Public Load Balancer Subnet
resource "oci_core_subnet" "service_lb_subnet" {
  cidr_block                 = var.LBSubnet-CIDR
  compartment_id             = var.compartment_ocid
  display_name               = "px-LBSubnet"
  dns_label                  = "lbsub5c69a4420"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = "${oci_core_default_route_table.px_oci_core_default_route_table.id}"
  security_list_ids          = ["${oci_core_vcn.px_oci_core_vcn.default_security_list_id}"]
  vcn_id                     = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Private Worker Node Subnet
resource "oci_core_subnet" "node_subnet" {
  cidr_block                 = var.NodeSubnet-CIDR
  compartment_id             = var.compartment_ocid
  display_name               = "px-NodeSubnet"
  dns_label                  = "sub0bf6bc66e"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = "${oci_core_route_table.px_oci_core_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.node_sec_list.id}"]
  vcn_id                     = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Public API EndPoint
resource "oci_core_subnet" "kubernetes_api_endpoint_subnet" {
  cidr_block                 = var.APISubnet-CIDR
  compartment_id             = var.compartment_ocid
  display_name               = "px-K8APIEndpointSubnet"
  dns_label                  = "subc0da0f69f"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = "${oci_core_default_route_table.px_oci_core_default_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.kubernetes_api_endpoint_sec_list.id}"]
  vcn_id                     = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Bastion Subnet
resource "oci_core_subnet" "px-bastion_subnet" {
  cidr_block                 = var.BastionSubnet-CIDR
  compartment_id             = var.compartment_ocid
  display_name               = "px-BastionSubnet"
  prohibit_public_ip_on_vnic = "false"
  route_table_id             = "${oci_core_default_route_table.px_oci_core_default_route_table.id}"
  security_list_ids          = ["${oci_core_security_list.bastion_public_sec_list.id}"]
  vcn_id                     = "${oci_core_vcn.px_oci_core_vcn.id}"
}

resource "oci_core_route_table" "px_oci_core_route_table" {
  compartment_id = var.compartment_ocid
  display_name   = "px-private-routetable"
  route_rules {
    description       = "traffic to the internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_nat_gateway.px_oci_core_nat_gateway.id}"
  }
  route_rules {
    description       = "traffic to OCI services"
    destination       = "all-lhr-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = "${oci_core_service_gateway.px_oci_core_service_gateway.id}"
  }
    vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

resource "oci_core_default_route_table" "px_oci_core_default_route_table" {
  display_name = "px-public-routetable"
  route_rules {
    description       = "traffic to/from internet"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.px_oci_core_internet_gateway.id}"
  }
  manage_default_resource_id = "${oci_core_vcn.px_oci_core_vcn.default_route_table_id}"
}

# Load Balancer Security List
resource "oci_core_security_list" "service_lb_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "px-svcxlbseclist"
  vcn_id         = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Worker Node Security List
resource "oci_core_security_list" "node_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "px-nodeseclist"
  egress_security_rules {
    description      = "Allow pods on one worker node to communicate with pods on other worker nodes"
    destination      = var.NodeSubnet-CIDR
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Access to Kubernetes API Endpoint"
    destination      = var.APISubnet-CIDR
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Kubernetes worker to control plane communication"
    destination      = var.APISubnet-CIDR
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.APISubnet-CIDR
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol         = "1"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Allow nodes to communicate with OKE to ensure correct start-up and continued functioning"
    destination      = "all-lhr-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "ICMP Access from Kubernetes Control Plane"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol         = "1"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Worker Nodes access to Internet"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  ingress_security_rules {
    description = "Allow pods on one worker node to communicate with pods on other worker nodes"
    protocol    = "all"
    source      = var.NodeSubnet-CIDR
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = var.APISubnet-CIDR
    stateless   = "false"
  }
  ingress_security_rules {
    description = "TCP access from Kubernetes Control Plane"
    protocol    = "6"
    source      = var.APISubnet-CIDR
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Inbound SSH traffic to worker nodes"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

resource "oci_core_security_list" "kubernetes_api_endpoint_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "px-k8ApiEndpoint"
  egress_security_rules {
    description      = "Allow Kubernetes Control Plane to communicate with OKE"
    destination      = "all-lhr-services-in-oracle-services-network"
    destination_type = "SERVICE_CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "All traffic to worker nodes"
    destination      = var.NodeSubnet-CIDR
    destination_type = "CIDR_BLOCK"
    protocol         = "6"
    stateless        = "false"
  }
  egress_security_rules {
    description      = "Path discovery"
    destination      = var.NodeSubnet-CIDR
    destination_type = "CIDR_BLOCK"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol         = "1"
    stateless        = "false"
  }
  ingress_security_rules {
    description = "External access to Kubernetes API endpoint"
    protocol    = "6"
    source      = "0.0.0.0/0"
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Kubernetes worker to Kubernetes API endpoint communication"
    protocol    = "6"
    source      = var.NodeSubnet-CIDR
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Kubernetes worker to control plane communication"
    protocol    = "6"
    source      = var.NodeSubnet-CIDR
    stateless   = "false"
  }
  ingress_security_rules {
    description = "Path discovery"
    icmp_options {
      code = "4"
      type = "3"
    }
  protocol    = "1"
  source      = var.NodeSubnet-CIDR
  stateless   = "false"
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Bastion Public Security List
resource "oci_core_security_list" "bastion_public_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "px-bastion_public_seclist"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  ingress_security_rules {
    protocol         = "1"           # ICMP
    source           = var.BastionSubnet-CIDR
    icmp_options {
      type = "3"                     # Destination Unreachable
    }
    stateless        = "false"
  }
  ingress_security_rules {
    protocol         = "6"           # TCP
    source           = "0.0.0.0/0"
    tcp_options {
      min = "22"
      max = "22"
    }
    stateless        = "false"
  }
  ingress_security_rules {
    protocol         = "1"           # ICMP
    source           = "0.0.0.0/0"
    icmp_options {
      type = "3"                     # Destination Unreachable
      code = "3"
    }
    stateless   = "false"
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Bastion Private Secuity List
resource "oci_core_security_list" "bastion_private_sec_list" {
  compartment_id = var.compartment_ocid
  display_name   = "px-bastion_private_seclist"
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"        # All
    stateless        = "false"
  }
  ingress_security_rules {
    protocol         = "6"          # TCP
    source           = var.BastionSubnet-CIDR
    tcp_options {
      min = "22"
      max = "22"
    }
    stateless        = "false"
  }
  ingress_security_rules {
    protocol         = "1"           # ICMP
    source           = var.BastionSubnet-CIDR
    stateless         = "false"
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}

# Service Gateway
resource "oci_core_service_gateway" "px_oci_core_service_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "px-sgw"
  services {
    service_id = "${data.oci_core_services.core_services.services[0].id}"
  }
  vcn_id = "${oci_core_vcn.px_oci_core_vcn.id}"
}
