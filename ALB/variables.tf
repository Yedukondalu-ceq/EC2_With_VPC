variable "project-name" {
  type        = string
  description = "Enter project name"
}

variable "Environment" {
  type        = string
  description = "Enter environment"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to attach to the resources"
}

variable "internal" {
  type        = bool
  description = "Enter internal"
}

variable "load_balancer_type" {
  type        = string
  description = "Enter load balancer type"
}

variable "security_groups" {
  type        = string
  description = "Enter security groups Id"
}

variable "subnets_id" {
  type        = list(string)
  description = "Enter subnets Id"
}

variable "deletion_protection" {
  type        = bool
  description = "Enter deletion protection"
}

variable "target_type" {
  type        = string
  description = "Enter target type"
}

variable "vpc_id" {
  type        = string
  description = "Enter vpc id"

}
