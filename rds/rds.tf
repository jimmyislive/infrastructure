
variable "env" { }
variable "master_db_name" {}
variable "master_username" {}
variable "master_password" {}
variable "aws_subnet_private1_id" {}
variable "aws_subnet_private2_id" {}
variable "aws_security_group_allow_inbound_from_within_vpc_id" {}


resource "aws_db_subnet_group" "main" {
    name = "main"
    description = "db subnet group"
    subnet_ids = ["${var.aws_subnet_private1_id}", "${var.aws_subnet_private2_id}"]

    tags {
        Name = "DB subnet group"
    }
}

resource "aws_db_instance" "main" {
  allocated_storage    = 5
  engine               = "postgres"
  engine_version       = "9.5.2"
  instance_class       = "db.t2.micro"
  name                 = "${var.master_db_name}"
  username             = "${var.master_username}"
  password             = "${var.master_password}"
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
  vpc_security_group_ids = ["${var.aws_security_group_allow_inbound_from_within_vpc_id}"]
}

output "aws_db_instance_address" {
  value = "${aws_db_instance.main.address}"
}


