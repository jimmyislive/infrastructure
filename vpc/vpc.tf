
variable "env" { }
variable "web_port" {}
variable "vpc_cidr" { }
variable "subnet_private1_cidr" { }
variable "subnet_private2_cidr" { }
variable "subnet_public_cidr" { }
variable "allow_all_cidr" { }

# vpc
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags {
    Name = "${var.env}"
  }
}

# subnets
resource "aws_subnet" "private1" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_private1_cidr}"
  availability_zone = "us-west-2b"

  tags {
    Name = "Private-${var.env}"
  }
}

resource "aws_subnet" "private2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_private2_cidr}"
  availability_zone = "us-west-2c"

  tags {
    Name = "Private-${var.env}"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.subnet_public_cidr}"
  availability_zone = "us-west-2a"

  tags {
    Name = "Public-${var.env}"
  }
}

# elastic ip
resource "aws_eip" "nat" {
  vpc = true
}

# internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "main"
    }
}

# nat gateway
resource "aws_nat_gateway" "natgw" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id = "${aws_subnet.public.id}"
}


# route tables
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags {
        Name = "public"
    }
}


resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "${var.allow_all_cidr}"
        nat_gateway_id = "${aws_nat_gateway.natgw.id}"
    }

    tags {
        Name = "private"
    }
}

# route table associations
resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private1" {
    subnet_id = "${aws_subnet.private1.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table_association" "private2" {
    subnet_id = "${aws_subnet.private2.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_security_group" "allow_inbound_from_within_vpc" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow_inbound_from_within_vpc"
  description = "Allow all inbound traffic originating within the vpc"

  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["${var.allow_all_cidr}"]
  }
}

resource "aws_security_group" "web_server" {
  vpc_id = "${aws_vpc.main.id}"
  name = "web_server"
  description = "Allow all inbound traffic on http"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["${var.allow_all_cidr}"]
  }

  ingress {
      from_port = "${var.web_port}"
      to_port = "${var.web_port}"
      protocol = "tcp"
      cidr_blocks = ["${var.allow_all_cidr}"]
  }

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.allow_all_cidr}"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["${var.allow_all_cidr}"]
  }
}

output "aws_subnet_private1_id" {
  value = "${aws_subnet.private1.id}"
}

output "aws_subnet_private2_id" {
  value = "${aws_subnet.private2.id}"
}

output "aws_subnet_public_id" {
  value = "${aws_subnet.public.id}"
}

output "aws_security_group_allow_inbound_from_within_vpc_id" {
  value = "${aws_security_group.allow_inbound_from_within_vpc.id}"
}

output "aws_security_group_web_server_id" {
  value = "${aws_security_group.web_server.id}"
}

