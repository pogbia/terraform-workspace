module "my_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true

  tags = local.common_tags
}


resource "aws_instance" "my_instance" {
  count = 2
  # 맵 형식으로 선언했기 때문에 var.ami_image[var.aws_region]
  #ami           = var.ami_image[var.aws_region]
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  tags                   = local.common_tags
  vpc_security_group_ids = [aws_security_group.my_sg_web.id]
  key_name               = aws_key_pair.my_sshkey.key_name
  subnet_id              = module.my_vpc.public_subnets["${count.index}"] # 리스트 - 0번

  #user_data = file(./web-deploy.sh)

  #user_data = <<-EOF
  ##!/bin/bash
  #sudo yum install -y httpd
  #sudo systemctl --now enable httpd
  #echo "<h1>Hello World </h1>" |  sudo tee /var/www/html/index.html
  #EOF

  # 프로비저너


  # provisioner "file" {
  #   source      = "./web-deploy.sh"
  #   destination = "/tmp/web-deploy.sh"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod +x /tmp/web-deploy.sh",
  #   "sudo /tmp/web-deploy.sh"]
  # }

  # provisioner "local-exec" {
  #   command = "echo ${self.public_ip} > ipaddr.txt"
  # }

  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = file("./my_sshkey")
  #     host        = self.public_ip
  #     timeout     = "10m"
  #   }
  #   provisioner "local-exec" {
  #     command = <<-EOF
  #       echo "${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=./my_sshkey" > inventory.ini
  #     EOF  
  #   }

  #   # ANSIBLE_HOST_KEY_CHECKING=False -> 핑거프린트 x
  #   provisioner "local-exec" {
  #     command = <<-EOF
  #       ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini playbook.yaml -b -T 100
  #     EOF  
  #   }
}
# resource "aws_key_pair" "my_sshkey" {
#   key_name   = "my_sshkey"
#   public_key = file("./my_sshkey.pub")
# }



resource "aws_eip" "my_eip" {
  count    = 2
  instance = aws_instance.my_instance["${count.index}"].id
  vpc      = true
  tags     = local.common_tags
}