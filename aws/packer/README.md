# Motivation

This is a simple example of how to build an Amazon AMI using packer.
I use Ubuntu as the OS to showcase how a custom AMI can be built based on what
you need in your AMI. The custom AMI contains contains several application
and security tools and such an AMI would be ideal for a CI/CD build agent.

# Pre-requisites

## AWS

### VPC, Subnet and Security Group

Ensure your VPC and a private subnet is set up. You need a security group that
allows SSH from your current network to your build subnet.

### IAM Privileges

Before you can build your AMI you need IAM privileges to create intermediate
resources and the final AMI in AWS.

Please refer to packer documentation for IAM here:
https://developer.hashicorp.com/packer/integrations/hashicorp/amazon#iam-task-or-instance-role

### AWS KeyPair

Create a AWS keypair and keep record of the keypair name
and the private key for SSH access during packer build.

### AWS Profile

Ensure you have setup your aws profile using `aws configure`, and accordingly
modify the `aws_profile` value in [ubuntu-pkrvars.hcl](ubuntu/ubuntu.pkrvars.hcl).

# Packer Run

Install packer, and run:

```
cd ubuntu
packer init .
packer build --var-file=ubuntu.pkrvars.hcl .
```

# Clean up AMIs

To clean up unused AMIs, run:

```
aws --profile <aws-profile> ec2 deregister-image --image-id <ami-id> --region <aws-region>
```