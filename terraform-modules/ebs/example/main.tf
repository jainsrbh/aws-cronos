module "ebs" {
  source            = "../"
  name              = "test"
  availability_zone = "ap-southeast-1a"
  prevent_destroy   = true
  size              = 10
}
