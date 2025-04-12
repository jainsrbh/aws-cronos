# README
# If there is more than a single match is returned by the search, Terraform will fail.
# Ensure that your search is specific enough to return a single AMI ID only,
# or use most_recent to choose the most recent one

# Existing AMI where the AWS account executing terraform is the owner
# Equivalent if you use the console and select "owned by me"

module "existing_ami_owned_by_me" {
  source = "../existing_ami"

  most_recent = true
  filter_name = ["oat-build-copy-ami-*"]
  owners      = ["self"]
}

# Using filter_root_device_type and/or filter_virtualization_type variables (these are optional)
module "existing_ami_owned_by_me" {
  source = "../existing_ami"

  most_recent = true
  owners      = ["self"]

  filter_name                = ["oat-build-copy-ami-*"]
  filter_root_device_type    = ["ebs"]
  filter_virtualization_type = ["hvm"]
}

# Existing AMI where another AWS account own the AMI and its been shared
# to the AWS Account used for terraform execution
# Equivalent if you use the console and select "Private Images"

module "existing_ami_private_image" {
  source = "../existing_ami"

  most_recent = true
  filter_name = ["logstash-v0.5.0-20220127-*"]
  owners      = ["977807541405"]
}

# Existing AMI where the visibility is Public and combines Owner-Alias
# either amazon, aws-marketplace, microsoft or a custom vendor
# Equivalent if you use the console and select "Public Images"

# Search for Official Ubuntu Image (from Canonical)
# AMI Name Pattern "ubuntu/images/hvm-ssd/ubuntu-$codename_firstword-$version_number-amd64-server-YYYYMMDD"
# $codename_firstword and $version_number can be found here https://wiki.ubuntu.com/Releases
# YYYYMMDD means the year month and day in GMT when the AMI is made public

module "existing_ami_public_image_ubuntu" {
  source = "../existing_ami"

  most_recent = true
  owners      = ["099720109477"]

  filter_name                = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*"]
  filter_virtualization_type = ["hvm"]
}


# Search for Official Amazon Linux 2 (from Amazon)
# AMI Name Pattern "amzn2-ami-hvm-2.0.YYYYMMDD.$custom_number-$platform-$storage_type"
# $incremental_digit can be 0 1 2 3 you get the idea
# $platform can be either "x86_64" or "arm64"
# $storage_type can be either "gp2" or "ebs"
# YYYYMMDD means the year month and day in GMT when the AMI is being build.
# More information can be found here https://aws.amazon.com/amazon-linux-2/

module "existing_ami_public_image_amzn2" {
  source = "../existing_ami"

  most_recent = true
  owners      = ["amazon"]
  filter_name = ["amzn2-ami-hvm-2.0.-*-x86_64*"]
}

# Using name_regex to filter locally results from filter_name and using aws-marketplace
module "existing_ami_public_image_marketplace" {
  source = "../existing_ami"

  most_recent = false
  filter_name = ["(New) Hyperledger*"]
  name_regex  = "^.*Chaincode.*"
  owners      = ["aws-marketplace"]
}
