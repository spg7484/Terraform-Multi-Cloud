variable "aws_region" {
  description = "AWS region where the Terraform state bucket will be created."
  type        = string
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "tags" {
  description = "Common tags applied to bootstrap resources."
  type        = map(string)
  default     = {}
}
