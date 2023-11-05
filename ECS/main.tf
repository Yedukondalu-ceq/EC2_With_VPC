resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name
# capacity_providers = [aws_ecs_capacity_provider.test.name]
  tags = {
    "env"       = "dev"
    "createdBy" = "binpipe"
  }
}

resource "aws_ecs_capacity_provider" "test" {
  name = "capacity-provider-test"
  auto_scaling_group_provider {
    
    #auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    auto_scaling_group_arn          = var.auto_scaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.web-cluster.name

  capacity_providers = [aws_ecs_capacity_provider.test.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.test.name
  }
}


resource "aws_ecs_task_definition" "task-definition-test" {
  family                = "web-family"
  container_definitions = file("${path.module}/container-definitions/container-def.json")
  network_mode          = "bridge"
  execution_role_arn    = "arn:aws:iam::528519205020:role/ECSTasExecutionRole"
  tags = {
    "env"       = "dev"
    "createdBy" = "yanam"
  }
}

resource "aws_ecs_service" "service" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = 6
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    #target_group_arn = aws_lb_target_group.lb_target_group.arn
    target_group_arn = var.target_group_arn
    container_name   = "binpipe-devops"
    container_port   = 80
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = "EC2"
#  depends_on  = [aws_lb_listener.web-listener]
}


resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "binpipe"
  }
}