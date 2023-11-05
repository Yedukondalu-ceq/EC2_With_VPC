variable "project-name" {
  type        = string
  description = "Enter project name"
}

variable "Environment" {
  type        = string
  description = "Enter environment"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "vpc_region" {
  type        = string
  description = "Region of the VPC"
}

variable "public_subnet_cidr_blocks" {
  type        = list(any)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  type        = list(any)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list(any)
  description = "List of availability zones"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to attach to the VPC resources"
}
