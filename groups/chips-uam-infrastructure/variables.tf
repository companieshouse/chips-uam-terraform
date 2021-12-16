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

variable "dns_prefix" {
  type        = string
  description = "The DNS prefix"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "ServiceTeam" {
  type        = string
  description = "The service team that supports the Cognos application"
  default     = "CSI"
}

# ------------------------------------------------------------------------------
# CHIPS UAM Frontend Variables - ALB 
# ------------------------------------------------------------------------------

variable "domain_name" {
  type        = string
  default     = "*.companieshouse.gov.uk"
  description = "Domain Name for ACM Certificate"
}

variable "fe_service_port" {
  type        = number
  default     = 8080
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

variable "chips_uam_logs" {
  type        = map(any)
  description = "Map of log file information; used to create log groups, IAM permissions and passed to the application to configure remote logging"
  default     = {}
}