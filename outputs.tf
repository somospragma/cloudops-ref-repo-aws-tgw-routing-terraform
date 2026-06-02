# =============================================================================
# Outputs del Módulo
# PC-IAC-007: Outputs (Salidas del Módulo)
# PC-IAC-014: Splat Expressions
# =============================================================================

output "route_table_ids" {
  description = "Mapa de IDs de las TGW Route Tables creadas, indexado por clave."
  value       = { for key, rt in aws_ec2_transit_gateway_route_table.this : key => rt.id }
}

output "route_table_arns" {
  description = "Mapa de ARNs de las TGW Route Tables creadas."
  value       = { for key, rt in aws_ec2_transit_gateway_route_table.this : key => rt.arn }
}

output "route_table_ids_list" {
  description = "Lista de todos los IDs de TGW Route Tables."
  value       = values(aws_ec2_transit_gateway_route_table.this)[*].id
}

output "association_ids" {
  description = "Mapa de IDs de las asociaciones creadas."
  value       = { for key, assoc in aws_ec2_transit_gateway_route_table_association.this : key => assoc.id }
}

output "propagation_ids" {
  description = "Mapa de IDs de las propagaciones creadas."
  value       = { for key, prop in aws_ec2_transit_gateway_route_table_propagation.this : key => prop.id }
}
