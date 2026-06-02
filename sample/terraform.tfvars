# =============================================================================
# Valores de Variables para el Ejemplo
# PC-IAC-026: Configuración declarativa sin IDs hardcodeados
# =============================================================================

client      = "pragma"
project     = "networking"
environment = "dev"
region      = "us-east-1"

deploy_role_arn = "arn:aws:iam::123456789012:role/TerraformDeployRole"

common_tags = {
  Client      = "pragma"
  Project     = "networking"
  Environment = "dev"
  Owner       = "cloudops-team"
  CostCenter  = "infrastructure"
}

# Transit Gateway ID - se llenará desde data source
transit_gateway_id = ""

# Route Tables a crear
route_table_config = {
  "spoke" = {
    additional_tags = { "Purpose" = "spoke-routing" }
  }
  "egress" = {
    additional_tags = { "Purpose" = "egress-return" }
  }
  "shared" = {
    additional_tags = { "Purpose" = "shared-return" }
  }
}

# Associations - IDs se llenarán desde data sources
association_config = {
  "egress-to-rt-egress" = {
    transit_gateway_attachment_id = "" # Se llenará
    route_table_key              = "egress"
  }
  "shared-to-rt-shared" = {
    transit_gateway_attachment_id = "" # Se llenará
    route_table_key              = "shared"
  }
}

# Propagations - IDs se llenarán desde data sources
propagation_config = {}

# Static Routes - IDs se llenarán desde data sources
static_route_config = {
  "spoke-default-to-egress" = {
    route_table_key                = "spoke"
    destination_cidr_block         = "0.0.0.0/0"
    transit_gateway_attachment_id  = "" # Se llenará con egress attachment
    blackhole                      = false
  }
  "spoke-shared-svc" = {
    route_table_key                = "spoke"
    destination_cidr_block         = "10.100.0.0/16"
    transit_gateway_attachment_id  = "" # Se llenará con shared attachment
    blackhole                      = false
  }
}
