variable "project_name" {
  description = "Prefix used for naming resources."
  type        = string
  default     = "app"
}

variable "environment" {
  description = "Environment name (e.g., dev, stage, prod)."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into EC2."
  type        = string
  default     = "0.0.0.0/0"
}

variable "ec2_instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Optional EC2 key pair name for SSH."
  type        = string
  default     = null
}

variable "db_name" {
  description = "RDS database name."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "RDS master username."
  type        = string
  default     = "adminuser"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB."
  type        = number
  default     = 20
}

variable "container_image_tag" {
  description = "Image tag to deploy in ECS from ECR."
  type        = string
  default     = "latest"
}

variable "ecs_task_cpu" {
  description = "CPU units for ECS Fargate task."
  type        = number
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory (MiB) for ECS Fargate task."
  type        = number
  default     = 512
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 1
}

variable "common_tags" {
  description = "Common tags applied to all taggable resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}
