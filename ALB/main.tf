# Create a Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name                       = "${var.project-name}-${var.Environment}-alb"
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = [var.security_groups]
  subnets                    = var.subnets_id
  enable_deletion_protection = var.deletion_protection
  tags = merge( 
  {
    Name = "${var.project-name}-${var.Environment}-alb"
  },
  var.tags
  )
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name                  = "${var.project-name}-${var.Environment}-tg"
  target_type           = var.target_type
  port                  = 80
  protocol              = "HTTP"
  vpc_id                = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }
 tags = merge( 
  {
    Name = "${var.project-name}-${var.Environment}-target_group"
  },
  var.tags
  )
  # lifecycle {
  #   create_before_destroy = true
  # }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn  = aws_lb.application_load_balancer.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}


