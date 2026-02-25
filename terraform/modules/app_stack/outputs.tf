output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "s3_bucket_name" {
  description = "S3 bucket name."
  value       = aws_s3_bucket.app.bucket
}

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.app.name
}

output "alb_dns_name" {
  description = "ALB DNS endpoint."
  value       = aws_lb.app.dns_name
}

output "ec2_instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "EC2 public IP."
  value       = aws_instance.app.public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint."
  value       = aws_db_instance.app.address
}

output "rds_db_name" {
  description = "RDS DB name."
  value       = aws_db_instance.app.db_name
}

output "rds_username" {
  description = "RDS DB username."
  value       = aws_db_instance.app.username
}

output "rds_password" {
  description = "RDS master password."
  value       = random_password.db_password.result
  sensitive   = true
}
