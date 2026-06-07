variable "vpc_id" {
  description = "VPC where security groups will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "Primary CIDR block for the VPC"
  type        = string
}
