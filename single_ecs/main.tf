#data "alicloud_images" "ubuntu" {
#  name_regex  = "^ubuntu"
#  most_recent = true
#}

resource "alicloud_security_group" "group" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_instance" "instance" {
  availability_zone          = "ap-southeast-5a" #Jakarta
  security_groups            = alicloud_security_group.group.*.id
  instance_type              = "ecs.t5-lc2m1.nano" # Burstable t5
  system_disk_category       = "cloud_efficiency"
  image_id                   = "centos_7_7_x64_20G_alibase_20200426.vhd" #"${data.alicloud_images.ubuntu.images.0.id}"
  instance_name              = "sample_test"
  vswitch_id                 = alicloud_vswitch.vswitch.id
  internet_max_bandwidth_out = 2
}

resource "alicloud_vpc" "vpc" {
  name       = "tf-vpc"
  cidr_block = "192.168.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-southeast-5a"
}

