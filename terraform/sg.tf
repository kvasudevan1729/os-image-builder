# create security group for packer builds

# to retrieve vpc id using data
//data "aws_vpc" "build_vpc" {
//  id = var.build_vpc_id
//}

resource "aws_security_group" "packer_ssh_sg" {
  name        = "packer-ssh-sg"
  description = "Allow SSH for packer"
  vpc_id      = var.build_vpc_id

  tags = {
    Name = "packer-ssh-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_rule" {
  security_group_id = aws_security_group.packer_ssh_sg.id
  cidr_ipv4         = var.source_ip_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_egress_all" {
  security_group_id = aws_security_group.packer_ssh_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}