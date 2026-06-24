output instance_public_ip {
  value       = aws_instance.my_ec2.public_ip
 
}

output "environment" {
  value = var.env
}

output "generated_string" {
  value = random_string.suffix.result
}

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}