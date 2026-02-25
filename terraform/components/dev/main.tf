module "app_stack" {
  source = "../../modules/app_stack"

  project_name         = var.project_name
  environment          = var.environment
  aws_region           = var.aws_region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  allowed_ssh_cidr     = var.allowed_ssh_cidr
  ec2_instance_type    = var.ec2_instance_type
  ec2_key_name         = var.ec2_key_name
  db_name              = var.db_name
  db_username          = var.db_username
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  container_image_tag  = var.container_image_tag
  ecs_task_cpu         = var.ecs_task_cpu
  ecs_task_memory      = var.ecs_task_memory
  ecs_desired_count    = var.ecs_desired_count
  common_tags          = var.common_tags
}
