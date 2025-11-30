output "instance_public_ip" {
  description = "Public IP of the Strapi EC2 instance"
  value       = aws_instance.strapi.public_ip
}

output "strapi_url" {
  description = "Base URL for Strapi"
  value       = "http://${aws_instance.strapi.public_ip}:1337"
}

