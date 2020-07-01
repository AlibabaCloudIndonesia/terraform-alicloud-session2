Alicloud Session 2: fun with ecs
terraform-alicloud-session2
---

Terraform module which creating various objectives on Alibaba Cloud. 

This repository includes:
* [Single ECS with Terraform](https://github.com/AlibabaCloudIndonesia/terraform-alicloud-session2/tree/master/single_ecs)
* [Multiple ECS with Terraform](https://github.com/AlibabaCloudIndonesia/terraform-alicloud-session2/tree/master/multiple_ecs)
* [Autoscaling ECS with Terraform](https://github.com/AlibabaCloudIndonesia/terraform-alicloud-session2/tree/master/autoscaling_ecs)

## Demos

| No | Name | Description | 
|----|------|-------------|
| 1 | Single ECS | Create an ECS instance by using Terraform |
| 2 | Multiple ECS | Create multiple ECS instances by using Terraform |
| 3 | Autoscaling | Create event-triggered autoscaling rule to ECS by using Terraform |

## Prerequisites

1. RAM User 
2. For Autoscaling, need to enable API Autoscaling and Cloud Monitor.

## Flow
1. Init

Terraform init used for initialize  working directory containing Terraform configuration file.
```hcl
$ terraform init
```

2. Plan 

Terraform plan used for create an execution plan.
```hcl
$ terraform plan
```

3. Apply

Terraform apply used for execute our plan.
```hcl
$ terraform apply
```
