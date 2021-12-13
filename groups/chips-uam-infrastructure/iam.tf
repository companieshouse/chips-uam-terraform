
module "chips_uam_profile" {
  source = "git@github.com:companieshouse/terraform-modules//aws/instance_profile?ref=tags/1.0.59"

  name       = "chips_uam_profile"
  enable_SSM = true
  cw_log_group_arns = [
    "${aws_cloudwatch_log_group.chips_uam.arn}:*",
    "${aws_cloudwatch_log_group.chips_uam.arn}:*:*",
  ]
  kms_key_refs = [
    "alias/${var.account}/${var.region}/ebs",
    local.ssm_kms_key_id
  ]
  s3_buckets_write = [local.session_manager_bucket_name]
  custom_statements = [
    {
      sid    = "AllowAccessToReleaseBucket",
      effect = "Allow",
      resources = [
        "arn:aws:s3:::shared-services.eu-west-2.resources.ch.gov.uk/*",
        "arn:aws:s3:::shared-services.eu-west-2.resources.ch.gov.uk"
      ],
      actions = [
        "s3:Get*",
        "s3:List*",
      ]
    }
  ]
}