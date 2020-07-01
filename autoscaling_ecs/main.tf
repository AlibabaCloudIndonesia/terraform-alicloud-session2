variable "name" {
  default = "essscalingconfiguration"
}

data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}

data "alicloud_instance_types" "default" {
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  cpu_core_count    = 1
  memory_size       = 2
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu_18.*64"
  most_recent = true
  owners      = "system"
}

resource "alicloud_vpc" "default" {
  name       = "${var.name}"
  cidr_block = "172.16.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vpc_id            = "${alicloud_vpc.default.id}"
  cidr_block        = "172.16.0.0/24"
  availability_zone = "${data.alicloud_zones.default.zones.0.id}"
  name              = "${var.name}"
}

resource "alicloud_security_group" "default" {
  name   = "${var.name}"
  vpc_id = "${alicloud_vpc.default.id}"
}

resource "alicloud_security_group_rule" "default" {
  type              = "ingress"
  ip_protocol       = "tcp"
  nic_type          = "intranet"
  policy            = "accept"
  port_range        = "22/22"
  priority          = 1
  security_group_id = "${alicloud_security_group.default.id}"
  cidr_ip           = "172.16.0.0/24"
}

resource "alicloud_ess_scaling_group" "default" {
  min_size           = 2
  max_size           = 3
  scaling_group_name = "${var.name}"
  removal_policies   = ["OldestInstance", "NewestInstance"]
  vswitch_ids        = ["${alicloud_vswitch.default.id}"]
}

resource "alicloud_ess_scaling_configuration" "default" {
  scaling_group_id  = "${alicloud_ess_scaling_group.default.id}"
  image_id          = "${data.alicloud_images.default.images.0.id}"
  instance_type     = "${data.alicloud_instance_types.default.instance_types.0.id}"
  security_group_id = "${alicloud_security_group.default.id}"
  force_delete      = true
  active            = true
}

resource "alicloud_ess_scaling_rule" "default" {
  scaling_group_id          = "${alicloud_ess_scaling_group.default.id}"
  metric_name               = "CpuUtilization"
  target_value              = 80
  scaling_rule_type         = "SimpleScalingRule"
  adjustment_type           = "TotalCapacity"
  adjustment_value          = 1
}
#nambah ess_alarm
resource "alicloud_ess_alarm" "default" {
  name                = "tf-testAccEssAlarm_basic"
  description         = "Acc alarm test"
  alarm_actions       = ["${alicloud_ess_scaling_rule.default.ari}"]
  scaling_group_id    = "${alicloud_ess_scaling_group.default.id}"
  metric_type         = "system"
  metric_name         = "CpuUtilization"
  period              = 60
  statistics          = "Average"
  threshold           = 60
  comparison_operator = ">="
  evaluation_count    = 2
}