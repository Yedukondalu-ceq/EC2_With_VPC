data "aws_ami" "amazon_linux2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  owners = ["amazon"]
}

/* data "aws_iam_instance_profile" "my_profile" {
  name = "pinkesh-tu"
} */

resource "aws_iam_instance_profile" "example_instance_profile" {
  name = "example-instance-profile"
  role = aws_iam_role.ecs_example_role.name
}

resource "aws_iam_role" "ecs_example_role" {
  name = "example-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}


# Create a launch configuration
resource "aws_launch_configuration" "tu-launch-config" {
  name_prefix                 = "${var.project-name}-${var.Environment}-lc"
  image_id                    = data.aws_ami.amazon_linux2.id
  instance_type               = var.instance_type
  security_groups             = [var.security_groups]
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.example_instance_profile.arn
 # user_data                   = file("${path.module}/script.sh")

#   lifecycle {
#     create_before_destroy = true
#   }
}

# Create a autoscaling group
resource "aws_autoscaling_group" "my-tu-autoscale" {
  launch_configuration  = aws_launch_configuration.tu-launch-config.name
  vpc_zone_identifier   = var.subnets_id
  target_group_arns     = [var.target_group_arns]
  health_check_type     = "EC2"
  min_size              = var.min_size
  desired_capacity      = var.desired_capacity
  max_size              = var.max_size

  tag {
    key                 = "Name"
    value               = "${var.project-name}-${var.Environment}-asg"
    propagate_at_launch = true
  }

}

/* # Create a scale_up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project-name}-${var.Environment}-scale_up"
  autoscaling_group_name = aws_autoscaling_group.my-tu-autoscale.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" # increasing instance by 1
  cooldown               = "300"
}
 */




/* # Create Cloudwatch alarm for CPU utilization > 30%
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.project-name}-${var.Environment}-scale_up_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.scalup_threshold  # New instance will be created once CPU utilization is higher than 30%
  alarm_description   = "Alarm when CPU utilization exceeds 30%"

  alarm_actions = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-tu-autoscale.name
  }
} */
/* 
# Create a scale_down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project-name}-${var.Environment}-scale_down"
  autoscaling_group_name = aws_autoscaling_group.my-tu-autoscale.name
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1
  cooldown               = "300"
} */
/* 
# Create Cloudwatch alarm for CPU utilization > 10 %
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.project-name}-${var.Environment}-scale_down_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.scaldown_threshold  # Instance will scale down when CPU utilization is lower than 10%
  alarm_description   = "Alarm when CPU utilization exceeds 10 %"

  alarm_actions = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my-tu-autoscale.name
  }
} */
