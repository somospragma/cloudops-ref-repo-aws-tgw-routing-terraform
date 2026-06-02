# =============================================================================
# Invocación del Módulo Padre (TGW Routing)
# PC-IAC-026: main.tf SOLO contiene el bloque module
# =============================================================================

module "tgw_routing" {
  source = "../"

  providers = {
    aws.project = aws.principal
  }

  # Variables de gobernanza
  client      = var.client
  project     = var.project
  environment = var.environment

  # PC-IAC-026: Configuraciones transformadas desde locals
  transit_gateway_id  = local.transit_gateway_id
  route_table_config  = local.route_table_config_transformed
  association_config  = local.association_config_transformed
  propagation_config  = local.propagation_config_transformed
  static_route_config = local.static_route_config_transformed
}
