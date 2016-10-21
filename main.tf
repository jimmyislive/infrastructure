
provider "aws" {}

variable "env" { }
variable "ami_id" {}
variable "account_num" { }
variable "web_port" {}
variable "vpc_cidr" { }
variable "subnet_private1_cidr" { }
variable "subnet_private2_cidr" { }
variable "subnet_public_cidr" { }
variable "allow_all_cidr" { }
variable "master_db_name" { }
variable "master_username" { }
variable "master_password" { }
variable "key_rsa_pub" { }


module "vpc" {
  source = "./vpc"

  env = "${var.env}"
  web_port = "${var.web_port}"
  vpc_cidr = "${var.vpc_cidr}"
  subnet_private1_cidr = "${var.subnet_private1_cidr}"
  subnet_private2_cidr = "${var.subnet_private2_cidr}"
  subnet_public_cidr = "${var.subnet_public_cidr}"
  allow_all_cidr = "${var.allow_all_cidr}"
}

module "sns" {
  source = "./sns"

  account_num = "${var.account_num}"
}

module "elasti_cache" {
  source = "./elasti_cache"

  env = "${var.env}"
  aws_subnet_private1_id = "${module.vpc.aws_subnet_private1_id}"
  aws_subnet_private2_id = "${module.vpc.aws_subnet_private2_id}"
  aws_security_group_allow_inbound_from_within_vpc_id =
                                                    "${module.vpc.aws_security_group_allow_inbound_from_within_vpc_id}"

}

module "rds" {
  source = "./rds"

  env = "${var.env}"
  master_db_name = "${var.master_db_name}"
  master_username = "${var.master_username}"
  master_password = "${var.master_password}"
  aws_subnet_private1_id = "${module.vpc.aws_subnet_private1_id}"
  aws_subnet_private2_id = "${module.vpc.aws_subnet_private2_id}"
  aws_security_group_allow_inbound_from_within_vpc_id =
                                                    "${module.vpc.aws_security_group_allow_inbound_from_within_vpc_id}"
}

module "ec2" {
  source = "./ec2"

  env = "${var.env}"
  ami_id = "${var.ami_id}"
  aws_security_group_web_server_id = "${module.vpc.aws_security_group_web_server_id}"
  aws_subnet_public_id = "${module.vpc.aws_subnet_public_id}"
  key_rsa_pub = "${var.key_rsa_pub}"
}

output "aws_eip_web_ip" {
  value = "${module.ec2.aws_eip_web_ip}"
}

output "aws_db_instance_address" {
  value = "${module.rds.aws_db_instance_address}"
}

output "aws_elasticache_cluster_node_address" {
  value = "${module.elasti_cache.aws_elasticache_cluster_node_address}"
}

