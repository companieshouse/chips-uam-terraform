
# ------------------------------------------------------------------------
# Locals
# ------------------------------------------------------------------------
locals {
  admin_cidrs        = values(data.vault_generic_secret.internal_cidrs.data)
  chips_uam_ec2_data = data.vault_generic_secret.chips_uam_ec2_data.data
  chips_uam_data     = data.vault_generic_secret.chips_uam_data.data

  #For each log map passed, add an extra kv for the log group name
  chips_uam_logs = { for log, map in var.chips_uam_logs : log => merge(map, { "log_group_name" = "${var.application}-${log}" }) }

  chips_uam_log_groups = compact([for log, map in local.chips_uam_logs : lookup(map, "log_group_name", "")])

  kms_keys_data          = data.vault_generic_secret.kms_keys.data
  account_ssm_key_arn    = local.kms_keys_data["ssm"]
  security_kms_keys_data = data.vault_generic_secret.security_kms_keys.data
  ssm_kms_key_id         = local.security_kms_keys_data["session-manager-kms-key-arn"]

  security_s3_data            = data.vault_generic_secret.security_s3_buckets.data
  session_manager_bucket_name = local.security_s3_data["session-manager-bucket-name"]

  elb_access_logs_bucket_name = local.security_s3_data["elb-access-logs-bucket-name"]
  elb_access_logs_prefix      = "elb-access-logs"

  internal_fqdn = format("%s.%s.aws.internal", split("-", var.aws_account)[1], split("-", var.aws_account)[0])

  chips_uam_ansible_inputs = {
    cw_log_files  = local.chips_uam_logs
    cw_agent_user = "root"
  }

  parameter_store_secrets = {
    master_data = local.chips_uam_data["master-txt"]
  }

  default_tags = {
    Terraform   = "true"
    Application = upper(var.application)
    Region      = var.aws_region
    Account     = var.aws_account
    Repository  = "chips-uam-terraform"
    Service     = "CHIPS"
  }
}