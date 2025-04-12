module "security_groups" {
  source = "../../security_groups"

  name_prefix = "example-dev-"
  vpc_id      = "vpc-00000000000000001"
  security_groups = {

    ec2_frontend = {
      description = "SG for frontend"
      ingress = {
        https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTPS from VPC"
        }
      }
      egress = {
        https = {
          from_port                = 443
          to_port                  = 443
          protocol                 = "tcp"
          source_security_group_id = "ec2_backend"
          description              = "HTTPS to ec2_backend sg"
        }
      }
    }

    ec2_backend = {
      description = "SG for ec2_backend"
      ingress = {
        https-legacy = {
          from_port                = 443
          to_port                  = 443
          protocol                 = "tcp"
          source_security_group_id = "sg-00000000000000000"
          description              = "HTTPS from legacy sg"
        }
        https = {
          from_port                = 443
          to_port                  = 443
          protocol                 = "tcp"
          source_security_group_id = "ec2_frontend"
          description              = "HTTPS from ec2_frontend sg"
        }
      }
    }

    functionbeat = {
      description = "FunctionBeat SG for example-dev"
      egress = {
        allow-https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTPS for VPC CIDR"
        }
      }
    }
    vpc-intrenal = {
      description = "SG for internal EC2 example-dev"
      egress = {
        allow-https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTPS for VPC CIDR"
        }
        allow-http = {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTP for VPC CIDR"
        }
      }
      ingress = {
        allow-https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTPS for VPC CIDR"
        }
      }
    }
    s3-gateway = {
      description = "SG for s3 gateway example-dev"
      egress = {
        allow-https = {
          from_port       = 443
          to_port         = 443
          protocol        = "tcp"
          prefix_list_ids = ["pl-000000"]
          description     = "HTTPS for s3 prefix list"
        }
      }
    }
    vpc-endpoints = {
      description = "SG for VPC Endpoints example-dev"
      egress = {
        allow-https = {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/8"]
          description = "HTTPS for VPC CIDR"
        }
      }
    }
  }
}
