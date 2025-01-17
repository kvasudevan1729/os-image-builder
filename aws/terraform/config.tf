terraform {
  backend "s3" {}
}

# To obtain the vpc id using shared tf state via data
//data "terraform_remote_state" "packer_vpc" {
//  backend = "s3"
//  config = {
//    bucket = "tf-vpc-bucket-example"
//    key    = "tf-vpc-example"
//    region = "eu-west-1"
//  }
//}
