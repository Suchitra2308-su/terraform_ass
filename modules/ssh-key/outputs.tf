output "key_name" {
  value = aws_key_pair.generated.key_name
}

output "private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}