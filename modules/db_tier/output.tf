
output "private_ip" {
  description = "private ip"
  value = "${aws_instance.db.private_ip}"
}
