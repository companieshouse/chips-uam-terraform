# ------------------------------------------------------------------------------
# Data
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  tags = {
    Name = "vpc-${var.aws_account}"
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-web-*"]
  }
}

data "aws_subnet_ids" "application" {
  vpc_id = data.aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["sub-application-*"]
  }
}

data "aws_security_group" "nagios_shared" {
  filter {
    name   = "group-name"
    values = ["sgr-nagios-inbound-shared-*"]
  }
}

data "aws_acm_certificate" "acm_cert" {
  domain = var.domain_name
}

data "aws_kms_key" "ebs" {
  key_id = "alias/${var.account}/${var.region}/ebs"
}

data "aws_kms_key" "logs" {
  key_id = "alias/${var.account}/${var.region}/logs"
}

data "vault_generic_secret" "account_ids" {
  path = "aws-accounts/account-ids"
}

data "vault_generic_secret" "chips_uam_ec2_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/chips/uam/ec2/"
}

data "vault_generic_secret" "security_kms_keys" {
  path = "aws-accounts/security/kms"
}

data "vault_generic_secret" "kms_keys" {
  path = "aws-accounts/${var.aws_account}/kms"
}

data "vault_generic_secret" "security_s3_buckets" {
  path = "aws-accounts/security/s3"
}

data "aws_ami" "chips_uam" {
  most_recent = true
  owners      = [data.vault_generic_secret.account_ids.data["development"]]

  filter {
    name = "name"
    values = [
      var.ami_name,
    ]
  }

  filter {
    name = "state"
    values = [
      "available",
    ]
  }
}

data "vault_generic_secret" "chips_uam_data" {
  path = "applications/${var.aws_account}-${var.aws_region}/chips/uam/master/"
}

data "template_file" "chips_uam_userdata" {
  template = file("${path.module}/templates/chips_uam_user_data.tpl")

  vars = {
    REGION               = var.aws_region
    ANSIBLE_INPUTS       = jsonencode(local.chips_uam_ansible_inputs)
    MASTER_DATA_PATH     = "/${var.application}/${var.environment}/master_data"
  }
}

data "template_cloudinit_config" "chips_uam_userdata_config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.chips_uam_userdata.rendered
  }
}

data "aws_route53_zone" "private_zone" {
  name         = local.internal_fqdn
  private_zone = true
}

data "vault_generic_secret" "internal_cidrs" {
  path = "aws-accounts/network/internal_cidr_ranges"
}