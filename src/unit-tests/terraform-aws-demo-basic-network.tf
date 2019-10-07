# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A VPC, 2 SUBNETS, INTERNET GATEWAY, DEFAULT ROUTE TABLE and DEFAULT SECURITY GROUP 
# and validate successful creation
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = "${var.aws_region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE VPC, 1st SUBNET, INTERNET GATEWAY, DEFAULT ROUTE TABLE and DEFAULT SECURITY GROUP 
# ---------------------------------------------------------------------------------------------------------------------
module "aws_basic_network" {
  source = "github.com/ecsdigital-demo-terraform-modules/terraform-aws-demo-basic-network"
  
  aws_core_vpc_cidr = "${var.var_aws_core_vpc_cidr}"
  aws_core_subnet_cidr1 = "${var.var_aws_core_subnet_cidr1}"
  owner_tag = "${var.var_owner_tag}"
  environment_tag = "${var.var_environment_tag}"
  prefix_tag = "${var.var_prefix_tag}"
  aws_core_az_1 = "${var.var_aws_core_az_1}"
  additional_public_cidrs = "${var.var_additional_public_cidrs}"
}


# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE 2nd SUBNET
# ---------------------------------------------------------------------------------------------------------------------
module "aws_subnet" {
  source = "github.com/ecsdigital-demo-terraform-modules/terraform-aws-demo-subnet"

  aws_subnet_az     = "${var.var_aws_subnet2_az}"
  aws_subnet_cidr   = "${var.var_aws_subnet2_cidr}"
  aws_vpc_id        = "${module.aws_basic_network.aws_vpc_id}"
  owner_tag         = "${var.var_owner_tag}"
  environment_tag   = "${var.var_environment_tag}"
  prefix_tag        = "${var.var_prefix_tag}"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE EC2 INSTANCES
# ---------------------------------------------------------------------------------------------------------------------
module "ec2_instances" {
  source = "github.com/ecsdigital-demo-terraform-modules/terraform-aws-demo-ec2"

  aws_ami_id             = "${data.aws_ami.amazon_linux.id}"
  aws_ec2_instance_count = "${var.var_aws_ec2_instance_count}"
  aws_ec2_instance_type  = "${var.var_aws_ec2_instance_type}"
  aws_ec2_key_name       = "${var.var_aws_ec2_key_name}"
  aws_ec2_sg_id          = "${module.aws_basic_network.aws_default_sg_id}"
  aws_ec2_subnet_id      = "${module.aws_basic_network.aws_subnet_id}"
  aws_ec2_volume_size    = "${var.var_aws_ec2_volume_size}"
  owner_tag              = "${var.var_owner_tag}"
  environment_tag        = "${var.var_environment_tag}"
  prefix_tag             = "${var.var_prefix_tag}"
}


# ---------------------------------------------------------------------------------------------------------------------
# AUTOMATICALLY CALUCULATE THE AMI ID FOR THE REGION
# ---------------------------------------------------------------------------------------------------------------------
data "aws_ami" "amazon_linux" {
most_recent = true
owners = ["amazon"] # Canonical

  filter {
      name   = "name"
      values = ["amzn2-ami-hvm*x86_64-gp2"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OUTPUT VARIABLE DECLARATION
# ---------------------------------------------------------------------------------------------------------------------
output "default_security_group_id" {
  value = "${module.aws_basic_network.aws_default_sg_id}"
}

output "subnet1_id" {
  value = "${module.aws_basic_network.aws_subnet_id}"
}

output "subnet2_id" {
  value = "${module.aws_subnet.aws_subnet_id}"
}

output "vpc_id" {
  value = "${module.aws_basic_network.aws_vpc_id}"
}

output "aws_instance_ids" {
    description = "Instance IDs of created EC2 resources."
    value = "${module.ec2_instances.aws_instance_ids}"
}

output "aws_instance_private_ips" {
    description = "Private IPs of created EC2 resources."
    value = "${module.ec2_instances.aws_instance_private_ips}"
}

output "aws_instance_public_ips" {
    description = "Public IPs of created EC2 resources."
    value = "${module.ec2_instances.aws_instance_public_ips}"
}