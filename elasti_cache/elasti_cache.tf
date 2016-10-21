
variable "env" { }
variable "aws_subnet_private1_id" {}
variable "aws_subnet_private2_id" {}
variable "aws_security_group_allow_inbound_from_within_vpc_id" {}

resource "aws_elasticache_subnet_group" "main_private" {
  name = "redis-subnet"
  description = "Elasti-Cache private subnet group"
  subnet_ids = ["${var.aws_subnet_private1_id}", "${var.aws_subnet_private2_id}"]
}

resource "aws_elasticache_cluster" "main" {
  cluster_id = "${var.env}"
  engine = "redis"
  engine_version = "2.8.24"
  node_type = "cache.t2.micro"
  port = 6379
  num_cache_nodes = 1
  parameter_group_name = "default.redis2.8"
  subnet_group_name = "${aws_elasticache_subnet_group.main_private.name}"
  security_group_ids = ["${var.aws_security_group_allow_inbound_from_within_vpc_id}"]
}

output "aws_elasticache_cluster_node_address" {
  value = "${aws_elasticache_cluster.main.cache_nodes.0.address}"
}
