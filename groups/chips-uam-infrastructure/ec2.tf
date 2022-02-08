# ------------------------------------------------------------------------------
# CHIPS UAM EC2 Security Group and rules
# ------------------------------------------------------------------------------
module "chips_uam_ec2_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "sgr-${var.application}-ec2-001"
  description = "Security group for the ${var.application} ec2"
  vpc_id      = data.aws_vpc.vpc.id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.chips_uam_internal_alb_security_group.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", var.ServiceTeam
    )
  )
}


resource "aws_cloudwatch_log_group" "chips_uam" {
  for_each = local.chips_uam_logs

  name              = each.value["log_group_name"]
  retention_in_days = lookup(each.value, "log_group_retention", var.default_log_group_retention_in_days)
  kms_key_id        = lookup(each.value, "kms_key_id", data.aws_kms_key.logs.arn)


  tags = merge(
    local.default_tags,
    map(
      "ServiceTeam", var.ServiceTeam
    )
  )
}

# ------------------------------------------------------------------------------
# CHIPS UAM EC2
# ------------------------------------------------------------------------------
module "chips_uam_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.19.0"

  name = var.ec2_name

  ami           = data.aws_ami.chips_uam.id
  key_name      = aws_key_pair.ec2_keypair.key_name
  instance_type = var.ec2_size
  subnet_id     = coalesce(data.aws_subnet_ids.application.ids...)
  vpc_security_group_ids = [
    module.chips_uam_ec2_security_group.this_security_group_id,
    data.aws_security_group.nagios_shared.id
  ]
  iam_instance_profile = module.chips_uam_profile.aws_iam_instance_profile.name
  user_data_base64     = data.template_cloudinit_config.chips_uam_userdata_config.rendered

  root_block_device = [
    {
      volume_size = "100"
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = data.aws_kms_key.ebs.arn
    }
  ]

  tags = merge(
    local.default_tags,
    map(
      "Name", var.application,
      "ServiceTeam", var.ServiceTeam,
      "Backup", var.retention_days,
      "BackupApp", var.application
    )
  )

  volume_tags = merge(
    local.default_tags,
    map(
      "Name", var.application,
      "ServiceTeam", var.ServiceTeam,
      "Backup", var.retention_days,
      "BackupApp", var.application
    )
  )
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = format("%s-%s", var.application, "ec2")
  public_key = local.chips_uam_ec2_data["public-key"]
}

resource "aws_lb_target_group_attachment" "ec2_alb_assoc" {
  target_group_arn = module.chips_uam_internal_alb.target_group_arns[0]
  target_id        = element(module.chips_uam_ec2.id, 0)
  port             = var.fe_service_port

  depends_on = [
    module.chips_uam_internal_alb
  ]
}
