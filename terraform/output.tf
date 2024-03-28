output "packer_sg_id" {
  value = aws_security_group.packer_ssh_sg.id
}