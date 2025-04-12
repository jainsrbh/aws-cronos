# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  vertical = "cronos"
  environment_tags = {
    environment = "dev"
  }
  ami_ubuntu = {
    owner = "099720109477"
    name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server*"
  }
  ami_amazon_linux = {
    owner = "137112412989"
    name = "al2023-ami-2023.7.20250331.0-kernel-6.1-x86_64"
  }
  ec2 = {
    jump = {
      type = "t3.micro"
    }
    node = {
      type = "t3.large"
    }
    web = {
      type = "t3.medium"
    }
  }
}
