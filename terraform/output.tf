output "packer_sg_id" {
  value = aws_security_group.packer_ssh_sg.id
}

output "packer_build_user" {
  value = aws_iam_user.packer_build.arn
}