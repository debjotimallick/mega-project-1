variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip" {
  type = bool
}

variable "key_name" {
  type = string
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "source_dest_check" {
  type    = bool
  default = true
}

variable "user_data" {
  type    = string
  default = ""
}
