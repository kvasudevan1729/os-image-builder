# Motivation

To be able to build the packer AMI we need certain AWS resources,
and this directory creates the security group and the IAM privileges required.

 - Security Group allows SSH access from the source node
 - IAM privileges includes [this](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon#iam-task-or-instance-role)
   and additional privileges to rotate the AWS keys. It would be best to use 
   an IAM role with the policies created here and attach the role to the
   instance profile. For instance profile, there is no need to include the 
   access key rotation policy.

# Terraform run

Modify `backend.conf` with your environment settings, and run:
```
terraform init -backend-config=backend.conf
terraform apply
```

Make note of the security group id from the output to use it for packer build.
The AWS administrator will need to create the access and secret key to start
with and the user can rotate the keys when required.
