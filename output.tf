output "my_eip" {
  value = aws_eip.my_eip.*.public_ip
}

output "my_pip" {
  value = aws_instance.my_instance.*.public_ip
}