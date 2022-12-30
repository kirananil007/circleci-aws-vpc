variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}