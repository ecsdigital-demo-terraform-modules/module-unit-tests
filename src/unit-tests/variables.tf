variable "aws_region" {
  description = "The AWS region to deploy into"
}

variable "var_additional_public_cidrs" {
    type = "list"
    description = "List of additional cidrs that need to be added to ingress rules. In format 1.2.3.4/32"
}

variable "var_aws_core_az_1" {
    type = "string"
    description = "Availability zone for first subnet of AWS core network"
}

variable "var_owner_tag" {
    type = "string"
    description = "Value that will be tagged as OWNER, on all AWS resources"
}

variable "var_environment_tag" {
    type = "string"
    description = "Value that will be tagged as ENVIRONMENT, on all AWS resources"
}

variable "var_prefix_tag" {
    type = "string"
    description = "Prefix string added to Name tag"
}

variable "var_aws_core_vpc_cidr" {
    type = "string"
    description = "VPC CIDR block for the AWS Core VPC"
}

variable "var_aws_core_subnet_cidr1" {
    type = "string"
    description = "CIDR block for first subnet of AWS Core network"
}

variable "var_aws_subnet2_cidr" {
    type = "string"
    description = "CIDR block for second subnet of AWS Core network"
}

variable "var_aws_subnet2_az" {
    type = "string"
    description = "Availability zone for second subnet of AWS Core network"
}

variable "var_aws_ec2_instance_count" {
    type = "string"
    description = "Number of AWS EC2 instances to create."
}


variable "var_aws_ec2_instance_type" {
    type = "string"
    description = "Type of EC2 instance to create."
}

variable "var_aws_ec2_key_name" {
    type = "string"
    description = "Name of AWS keypair to associate with the EC2 Instance."
}


variable "var_aws_ec2_volume_size" {
    type = "string"
    description = "Size of EBS volume to create."
}
