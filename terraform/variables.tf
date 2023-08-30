variable "instance_name" {
  type    = string
  default = "Terraform Spot Instance"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_max_price" {
  type    = number
  default = 0.004
}

variable "ssh_key_name" {
  type    = string
  default = "frankfurt"
}

variable "ebs_volume_id" {
  type = string
  default = "vol-05be9c5993ebcf10e"
}

variable "root_volume_size" {
  type = number
  default = 12
}