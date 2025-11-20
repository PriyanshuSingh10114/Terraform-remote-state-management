variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_default_root_storage_size" {
  type    = number
  default = 10
}

variable "ec2_ami_id" {
  type    = string
  default = "ami-02b8269d5e85954ef"
}

variable "env" {
  type    = string
  default = "dev"
}
