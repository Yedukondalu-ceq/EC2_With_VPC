variable "project-name" {
  type        = string
  description = "Enter project name"
}

variable "Environment" {
  type        = string
  description = "Enter environment"
}

variable "vpc_id" {
  type        = string
  description = "Enter vpc_id"
}

variable "web_port"{
  type        = number
  description = "Enter web_port"
}

variable "allowed_ports" {
  type        = list(number)
  description = "Enter a list of allowed ports"
}

variable "protocol" {
   type        = string
   default     = "tcp"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to attach to the resources"
}

variable "rds_port" {
   type        = number
   description = "Enter from_port"
}
