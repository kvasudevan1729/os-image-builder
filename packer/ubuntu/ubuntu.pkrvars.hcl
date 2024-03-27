aws_profile = "packer-build"
aws_region = "<aws region>"
subnet_id = "<private subnet>"
security_group_id = "<security group that allows ssh>"
base_ami_id = "ami-0b9932f4918a00c4f" #Ubuntu 22.04 in eu-west-2
ssh_keypair_name = "<aws-keypair-name>"
ssh_private_key_file = "<aws-keypair-ssh-private-key>"
kubectl_version = "1.29.2"