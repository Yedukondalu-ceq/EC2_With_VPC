resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    {
      Name             = "${var.project-name}-${var.Environment}-vpc"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id          = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name        = "${var.project-name}-${var.Environment}-IGW",

    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    {
      Name        = "${var.project-name}-${var.Environment}-PublicRouteTable",
    },
    var.tags
  )
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name          = "${var.project-name}-${var.Environment}-PrivateSubnet",

    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name                = "${var.project-name}-${var.Environment}-PublicSubnet",

    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# resource "aws_route_table" "private" {
#   count           = length(var.private_subnet_cidr_blocks)
#   vpc_id          = aws_vpc.my_vpc.id

#   tags = merge(
#     {
#       Name        = "${var.project-name}-${var.Environment}-PrivateRouteTable",

#     },
#     var.tags
#   )
# }

# resource "aws_route" "private" {
#   count                  = length(var.private_subnet_cidr_blocks)
#   route_table_id         = aws_route_table.private[count.index].id
#   destination_cidr_block = "0.0.0.0/0"
#   # nat_gateway_id         = aws_nat_gateway.NATgw[count.index].id
# }



# resource "aws_route_table_association" "private" {
#   count          = length(var.private_subnet_cidr_blocks)
#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private[count.index].id
# }


# resource "aws_eip" "my_eip" {
#   count = length(var.public_subnet_cidr_blocks)
#   vpc   = true
# }

# resource "aws_nat_gateway" "NATgw" {
#   depends_on      = [aws_internet_gateway.igw]
#   count           = length(var.public_subnet_cidr_blocks)
#   allocation_id   = aws_eip.my_eip[count.index].id
#   subnet_id       = aws_subnet.public[count.index].id

#   tags = merge(
#     {
#       Name        = "${var.project-name}-${var.Environment}-NATgw",

#     },
#     var.tags
#   )
# }

