module "ec2" {
  source            = "../"
  name              = "test"
  availability_zone = "ap-southeast-1a"
  ami               = "ami-07f179dc333499419"
  subnet_id         = "sub-0123456789"
  ebs_block_devices = {
    "test" = {
      "device_name" = "/dev/sdh"
      "ebs_id"      = "vol-0f552e3082c7add40"
    }
  }
}
