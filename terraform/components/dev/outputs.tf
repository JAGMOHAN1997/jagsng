output "vpc_id" {
  description = "VPC ID."
  value       = module.app_stack.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.app_stack.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.app_stack.private_subnet_ids
}

output "s3_bucket_name" {
  description = "S3 bucket name."
  value       = module.app_stack.s3_bucket_name
}

output "ecr_repository_url" {
  description = "ECR repository URL."
  value       = module.app_stack.ecr_repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name."
  value       = module.app_stack.ecs_cluster_name
}

output "ecs_service_name" {
  description = "ECS service name."
  value       = module.app_stack.ecs_service_name
}

output "alb_dns_name" {
  description = "ALB DNS endpoint."
  value       = module.app_stack.alb_dns_name
}

output "ec2_instance_id" {
  description = "EC2 instance ID."
  value       = module.app_stack.ec2_instance_id
}

output "ec2_public_ip" {
  description = "EC2 public IP."
  value       = module.app_stack.ec2_public_ip
}

output "rds_endpoint" {
  description = "RDS endpoint."
  value       = module.app_stack.rds_endpoint
}

output "rds_db_name" {
  description = "RDS DB name."
  value       = module.app_stack.rds_db_name
}

output "rds_username" {
  description = "RDS DB username."
  value       = module.app_stack.rds_username
}

output "rds_password" {
  description = "RDS master password."
  value       = module.app_stack.rds_password
  sensitive   = true
}
