resource "aws_ssm_parameter" "parameters" {
  for_each = local.parameter_store_secrets

  name   = "/${var.application}/${var.environment}/${each.key}"
  type   = "SecureString"
  value  = each.value
  key_id = local.account_ssm_key_arn

  tags = {
    Environment = var.environment
    Application = var.application
  }
}