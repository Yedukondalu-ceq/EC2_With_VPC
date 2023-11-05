variable "project-name" {
  type        = string
  description = "Enter project name"
}

variable "Environment" {
  type        = string
  description = "Enter environment"
}

variable "instance_type" {
  type        = string
  description = "Enter instance type"
}

variable "security_groups" {
  type        = string
  description = "Enter security groups"
}

variable "associate_public_ip_address" {
  type        = bool
  default     = true
}

variable "key_name" {
  type        = string
  description = "Enter key name"
}

variable "subnets_id" {
  type        = list(string)
  description = "Enter subnets_id"
}

variable "target_group_arns" {}

variable "min_size" {
  type        = number
  description = "Enter min_size" 
}

variable "desired_capacity" {
  type        = number
  description = "Enter desired capacity" 
}

variable "max_size" {
  type        = number
  description = "Enter max_size" 
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to attach to the resources"
}

variable "scalup_threshold" {
  type        = string
  description = "Enter scalup_threshold"
}

variable "scaldown_threshold" {
  type        = string
  description = "Enter scalup_threshold"
}