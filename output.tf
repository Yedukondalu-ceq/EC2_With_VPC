output "vpc_id" {
  value = module.vpc[0].vpc_id
}
output "public_subnet_ids" {
  value       = module.vpc[0].public_subnet_ids
  description = "List of public subnet IDs"
}
output "private_subnet_ids" {
  value       = module.vpc[0].private_subnet_ids
  description = "List of private subnet IDs"
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}


#============ Yanam RDS Output ======================

/* output "db_instance_source_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_source_endpoint
} */

# WE need to change this oupt values 



/* output "db_instance_replica_arn" {
  description = "The ARN of the Replica RDS instance"
  value       = module.rds.db_instance_replica_arn
} */


/* output "db_instance_Replication_endpoint" {
  description = "The connection endpoint"
  value       = module.rds.db_instance_Replication_endpoint
} */

