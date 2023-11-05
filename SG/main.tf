# Create security group for load balancer

resource "aws_security_group" "alb_sg" {
  name               = "${var.project-name}-${var.Environment}-alb_sg"
  description        = "ALB security group"
  vpc_id             = var.vpc_id

  ingress {
    from_port        = var.web_port
    to_port          = var.web_port
    protocol         = var.protocol
    description      = "ALB security group"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
  {
    Name    = "${var.project-name}-${var.Environment}-alb_sg"
    Project = var.project-name
  },
  var.tags
  )
}

# Create security group for webserver
resource "aws_security_group" "webserver_sg" {
  name               = "${var.project-name}-${var.Environment}-webserver_sg"
  description        =  "EC2 security group"
  vpc_id             = var.vpc_id
  dynamic "ingress" {
    for_each = toset(var.allowed_ports)
    content {
      description = "EC2 security group"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = var.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
  {
    Name    = "${var.project-name}-${var.Environment}-webserver_sg"
    Project = var.project-name
  },
  var.tags
  )
}

#create a RDS security_group
resource "aws_security_group" "rds_sg" {
 # name_rds_sg   = var.name_rds_sg
  vpc_id        = var.vpc_id
   
  ingress {
    from_port   = var.rds_port
    to_port     = var.rds_port
    protocol    = var.protocol
    security_groups = [aws_security_group.webserver_sg.id]
  }

  tags = merge(
  {
    Name    = "${var.project-name}-${var.Environment}-rds_sg"
    Project = var.project-name
  },
  var.tags
  )
}