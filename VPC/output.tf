output "vpc_id" {
  value       = aws_vpc.my_vpc.id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "List of private subnet IDs"
}

output "subnet_id" {
  value = concat(aws_subnet.public.*.id, aws_subnet.private.*.id)
}

output "cidr_block" {
  value       = var.cidr_block
  description = "The CIDR block associated with the VPC"
}

output "region" {
  value = var.vpc_region
  description = "Region"
}

