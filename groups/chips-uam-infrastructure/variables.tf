# ------------------------------------------------------------------------------
# Vault Variables
# ------------------------------------------------------------------------------
variable "vault_username" {
  type        = string
  description = "Username for connecting to Vault - usually supplied through TF_VARS"
}

variable "vault_password" {
  type        = string
  description = "Password for connecting to Vault - usually supplied through TF_VARS"
}

# ------------------------------------------------------------------------------
# AWS Variables
# ------------------------------------------------------------------------------
variable "aws_region" {
  type        = string
  description = "The AWS region in which resources will be administered"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile to use"
}

variable "aws_account" {
  type        = string
  description = "The name of the AWS Account in which resources will be administered"
}

# ------------------------------------------------------------------------------
# AWS Variables - Shorthand
# ------------------------------------------------------------------------------

variable "account" {
  type        = string
  description = "Short version of the name of the AWS Account in which resources will be administered"
}

variable "region" {
  type        = string
  description = "Short version of the name of the AWS region in which resources will be administered"
}

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------

variable "application" {
  type        = string
  description = "The name of the application"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

# ------------------------------------------------------------------------------
# CHIPS UAM Frontend Variables - ALB 
# ------------------------------------------------------------------------------

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "public_allow_cidr_blocks" {
  type        = list(any)
  default     = ["0.0.0.0/0"]
  description = "cidr block for allowing inbound users from internet"
}

variable "fe_service_port" {
  type        = number
  default     = 80
  description = "Target group backend port"
}

variable "fe_health_check_path" {
  type        = string
  default     = "/"
  description = "Target group health check path"
}

# ------------------------------------------------------------------------------
# EC2 Variables
# ------------------------------------------------------------------------------

variable "log_group_retention_in_days" {
  type        = number
  default     = 7
  description = "Total days to retain logs in CloudWatch log group"
}

variable "ec2_name" {
  description = "Name to be used on all resources as prefix"
  type        = string
}

variable "ec2_size" {
  type        = string
  description = "The size of the ec2 instance"
}

variable "ami_name" {
  type        = string
  default     = "amzn2-base-*"
  description = "Name of the AMI to use in the Auto Scaling configuration for email servers"
}