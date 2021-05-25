variable "aws_region" {
  type    = string
  default = "ap-northeast-1"
}

variable "ami_image" {
  type = map(string)
  default = {
    ap-northeast-1 = "ami-08cea9d1e49a15c34" # 18.04
    ap-northeast-2 = "ami-0be9734c9e68b99f4" # 20.04
  }
} # var.ami_image[ap-northeast-2]

variable "instance_type" {
  type    = string
  default = "t3.small"
}


variable "project_name" {
  type    = string
  default = "my_project"
}

variable "project_env" {
  type    = string
  default = "terraform"
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

# variable "ssh_client_ip" {
#   type = string
# }

# variable "instance-count" {
#   type = number
#   default = 2
# }