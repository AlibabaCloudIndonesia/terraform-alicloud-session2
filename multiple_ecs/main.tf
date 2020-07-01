#data "alicloud_images" "ubuntu" {
#  name_regex  = "^ubuntu"
#  most_recent = true
#}


resource "alicloud_vpc" "vpc" {
  name       = "tf-vpc"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_security_group" "group" {
  name        = "tf_test_foo"
  description = "foo"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "ap-southeast-5b"
}

resource "alicloud_security_group_rule" "allow_all_tcp" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "1/65535"
  priority          = 1
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = "0.0.0.0/0"
}

module "tf-instances" {
  source = "alibaba/ecs-instance/alicloud"
  vswitch_id = alicloud_vswitch.vswitch.id
  group_ids = [alicloud_security_group.group.id]
  private_ips = ["172.16.0.110","172.16.0.111"]
  disk_category = "cloud_efficiency"
  disk_name = "my_module_disk"
  image_id = "centos_7_7_x64_20G_alibase_20200426.vhd"
  disk_size = "21"
  number_of_disks = "3"
  system_disk_size = "20"
  internet_max_bandwidth_out = 1
  instance_name = "my_module_instances_"
  host_name = "sample"
  internet_charge_type = "PayByTraffic"
  number_of_instances = "2"
  password = "User@123"
  instance_type  = "ecs.t5-lc2m1.nano"
  
}