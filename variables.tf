variable "region" {
  default     = "us-west-2"
  description = "The AWS region that resources will be deployed into"
  type        = string
}

variable "default_tags" {
  default = {
    Environment = "dev"
    Owner       = "Jeremy"
    Terraform   = "true"
  }
  description = "Default tags to apply to resources"
  type        = map(string)
}
