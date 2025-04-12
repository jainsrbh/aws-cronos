module "network" {
  source = "../"

  name_prefix    = "example"
  nat_type       = null
  vpc_cidr_block = "10.50.0.0/16"

  availability_zones = {
    "ap-southeast-1a" = {
      public_cidr = "10.50.10.0/24"
      private_cidrs = {
        ecs = "10.50.20.0/24"
        ec2 = "10.50.30.0/24"
      }
    }
    "ap-southeast-1b" = {
      public_cidr = "10.50.11.0/24"
      private_cidrs = {
        ecs = "10.50.21.0/24"
        ec2 = "10.50.31.0/24"
      }
    }
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    ec2 = {
      "kubernetes.io/role/internal-elb" = "1"
      "karpenter.sh/discovery"          = "private"
    }
  }
}
