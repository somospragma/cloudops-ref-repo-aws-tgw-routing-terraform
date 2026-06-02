# =============================================================================
# Outputs del Ejemplo
# =============================================================================

output "route_table_ids" {
  description = "IDs de las TGW Route Tables creadas."
  value       = module.tgw_routing.route_table_ids
}

output "association_ids" {
  description = "IDs de las asociaciones creadas."
  value       = module.tgw_routing.association_ids
}

output "propagation_ids" {
  description = "IDs de las propagaciones creadas."
  value       = module.tgw_routing.propagation_ids
}
