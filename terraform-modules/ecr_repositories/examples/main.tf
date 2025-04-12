module "short" {
  source = "../"

  name_prefix = "vertical/project-name/"
  repositories = {
    proxy    = {}
    frontend = {}
    backend  = {}
  }
}

module "full" {
  source = "../"

  name_prefix = "vertical/project-name/"
  repositories = {
    proxy    = {}
    frontend = {}
    backend  = {}
  }
  # Defaults:
  image_tag_mutability       = "IMMUTABLE"
  principals_readonly_access = []
  principals_full_access     = []
  principals_lambda_access   = []
  scan_on_push               = true
  kms_key                    = null
  tags                       = {}
}

module "read-from-lambda" {
  source = "../"

  name_prefix = "vertical/project-name/"
  repositories = {
    proxy = {}
  }
  services_readonly_access = ["lambda"]
}
