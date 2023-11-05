module "vpc" {
  source                     = "../VPC"
  for_each                   = var.vpc_variable
  project-name               = var.project-name
  Environment                = var.Environment
  vpc_region                 = var.region
  cidr_block                 = each.value.cidr_block
  public_subnet_cidr_blocks  = each.value.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = each.value.private_subnet_cidr_blocks
  availability_zones         = each.value.availability_zones
  tags                       = var.common_tags
}

module "sg" {
  source        = "../SG"
  project-name  = var.project-name
  Environment   = var.Environment
  vpc_id        = module.vpc[0].vpc_id
  web_port      = var.web_port
  allowed_ports = var.allowed_ports
  rds_port      = var.rds_port
  tags          = var.common_tags
}

module "alb" {
  source              = "../ALB"
  project-name        = var.project-name
  Environment         = var.Environment
  internal            = var.internal
  load_balancer_type  = var.load_balancer_type
  security_groups     = module.sg.alb_sg_id
  subnets_id          = module.vpc[0].public_subnet_ids
  deletion_protection = var.deletion_protection
  target_type         = var.target_type
  vpc_id              = module.vpc[0].vpc_id
  tags                = var.common_tags
}

module "asg" {
  source             = "../ASG"
  project-name       = var.project-name
  Environment        = var.Environment
  instance_type      = var.instance_type
  security_groups    = module.sg.webserver_sg_id
  key_name           = var.key_name
  subnets_id         = module.vpc[0].public_subnet_ids
  target_group_arns  = module.alb.target_group_arns
  min_size           = var.min_size
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  scalup_threshold   = var.scalup_threshold
  scaldown_threshold = var.scaldown_threshold
  tags               = var.common_tags
}

module "ecs" {
  source = "../ECS"
  auto_scaling_group_arn = module.asg.autoscale_arn
  target_group_arn = module.alb.target_group_arns
  
}