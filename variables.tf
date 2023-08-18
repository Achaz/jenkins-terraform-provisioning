variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

