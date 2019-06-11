variable "name" {
  description="name of the app"
}

variable "db_ami_id" {
  description="ami-c2b8bfbb"
}
variable "vpc_id" {
  description="vpc of both subnet"
}

variable "user_data" {
  description = "user data to pass to the instance"
}

variable "private_ip" {
  description = "private_ip"
}

variable "security_group_id" {
  description = "security group"
}

variable "cidr_block" {
  description = "cidr block"
  default = "10.0.0.0/16"
}
