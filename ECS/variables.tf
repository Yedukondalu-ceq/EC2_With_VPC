variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
  default     = "terraform_workshop_cluster"
}

variable "auto_scaling_group_arn" { 
}

variable "target_group_arn" {
}