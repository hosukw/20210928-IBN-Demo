provider "aws" {
    region = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "ise_password" {}
variable "ad_admin_password" {}
variable "ise_domain" {}
variable "ppan_name" {}
variable "span_name" {}

# aws_vpc-subnet.tf
# Create VPC - 10.0.0.0/16
# Create Internet Gateway
# VGW Attachment - To on-premises network (The VPN is already pre-configured, just attaching existing VGW to VPC)
# Modify the default route table - To allow Outbound Internet via IGW and to on-premises via VGW
# Create Subnets - 10.0.1.0/24 & 10.0.2.0/24 on separate AZ
# Associate subnet with the default route table
# Create Security Group - Full access among hosts in VPC, full access from on-premises, SSH from anywhere

# aws_instances.tf
# Bring up ISE interfaces & instances
# Also includes test ubuntu instance for testing Terraform capabilities

# aws_loadbalancer.tf
# Create TG - UDP/1812, UDP/1813, TCP/49
# Attach Target Group 
# Create Load balancer - VIP: 10.0.1.20 & 10.0.2.20
# Create LB listener and tie them to the target groups

# aws_route53.tf
# Route 53 - Add ISE records for the forward and reverse zones

# aws_output.tf
# Create Ansible variable file with dynamic IP addresses
# Create userdata files for ISE intances