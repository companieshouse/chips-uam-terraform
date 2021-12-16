# chips-uam-infrastructure-terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0, < 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 0.3, < 4.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 0.3, < 4.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_chips_uam_ec2"></a> [chips\_uam\_ec2](#module\_chips\_uam\_ec2) | terraform-aws-modules/ec2-instance/aws | 2.19.0 |
| <a name="module_chips_uam_ec2_security_group"></a> [chips\_uam\_ec2\_security\_group](#module\_chips\_uam\_ec2\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |
| <a name="module_chips_uam_internal_alb"></a> [chips\_uam\_internal\_alb](#module\_chips\_uam\_internal\_alb) | terraform-aws-modules/alb/aws | ~> 5.0 |
| <a name="module_chips_uam_internal_alb_security_group"></a> [chips\_uam\_internal\_alb\_security\_group](#module\_chips\_uam\_internal\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 3.0 |
| <a name="module_chips_uam_profile"></a> [chips\_uam\_profile](#module\_chips\_uam\_profile) | git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.59 |  |
| <a name="module_internal_alb_proxy_metrics"></a> [internal\_alb\_proxy\_metrics](#module\_internal\_alb\_proxy\_metrics) | git@github.com:companieshouse/terraform-modules//aws/alb-metrics?ref=tags/1.0.26 |  |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.chips_uam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_key_pair.ec2_keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_lb_target_group_attachment.ec2_alb_assoc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_route53_record.chips_uam_alb_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate.acm_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/acm_certificate) | data source |
| [aws_ami.chips_uam](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_route53_zone.private_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_group.nagios_shared](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet_ids.application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_subnet_ids.web](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_cloudinit_config.chips_uam_userdata_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/cloudinit_config) | data source |
| [template_file.chips_uam_userdata](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [vault_generic_secret.account_ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chips_uam_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.chips_uam_ec2_data](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.internal_cidrs](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_kms_keys](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |
| [vault_generic_secret.security_s3_buckets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/generic_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ServiceTeam"></a> [ServiceTeam](#input\_ServiceTeam) | The service team that supports the Cognos application | `string` | `"CSI"` | no |
| <a name="input_account"></a> [account](#input\_account) | Short version of the name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | Name of the AMI to use in the Auto Scaling configuration for email servers | `string` | `"amzn2-base-*"` | no |
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | The name of the AWS Account in which resources will be administered | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | The AWS profile to use | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_chips_uam_logs"></a> [chips\_uam\_logs](#input\_chips\_uam\_logs) | Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging | `map(any)` | `{}` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | The DNS prefix | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain Name for ACM Certificate | `string` | `"*.companieshouse.gov.uk"` | no |
| <a name="input_ec2_name"></a> [ec2\_name](#input\_ec2\_name) | Name to be used on all resources as prefix | `string` | n/a | yes |
| <a name="input_ec2_size"></a> [ec2\_size](#input\_ec2\_size) | The size of the ec2 instance | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_fe_health_check_path"></a> [fe\_health\_check\_path](#input\_fe\_health\_check\_path) | Target group health check path | `string` | `"/"` | no |
| <a name="input_fe_service_port"></a> [fe\_service\_port](#input\_fe\_service\_port) | Target group backend port | `number` | `8080` | no |
| <a name="input_log_group_retention_in_days"></a> [log\_group\_retention\_in\_days](#input\_log\_group\_retention\_in\_days) | Total days to retain logs in CloudWatch log group | `number` | `7` | no |
| <a name="input_region"></a> [region](#input\_region) | Short version of the name of the AWS region in which resources will be administered | `string` | n/a | yes |
| <a name="input_vault_password"></a> [vault\_password](#input\_vault\_password) | Password for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |
| <a name="input_vault_username"></a> [vault\_username](#input\_vault\_username) | Username for connecting to Vault - usually supplied through TF\_VARS | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_chips_uam_frontend_address_internal"></a> [chips\_uam\_frontend\_address\_internal](#output\_chips\_uam\_frontend\_address\_internal) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->