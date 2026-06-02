# =============================================================================
# Transformaciones del Ejemplo
# PC-IAC-026: Patrón de Transformación en sample/
# PC-IAC-025: Procesamiento Obligatorio de Gobernanza en el Root
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Prefijo de Gobernanza
  # ---------------------------------------------------------------------------
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # ---------------------------------------------------------------------------
  # Transit Gateway ID dinámico
  # ---------------------------------------------------------------------------
  transit_gateway_id = length(var.transit_gateway_id) > 0 ? var.transit_gateway_id : data.aws_ec2_transit_gateway.selected.id

  # ---------------------------------------------------------------------------
  # Route Tables con nombre inyectado (PC-IAC-025)
  # ---------------------------------------------------------------------------
  route_table_config_transformed = {
    for key, config in var.route_table_config : key => merge(config, {
      name = "${local.governance_prefix}-tgw-rt-${key}"
    })
  }

  # ---------------------------------------------------------------------------
  # Associations con IDs dinámicos
  # ---------------------------------------------------------------------------
  attachment_ids = {
    "egress" = data.aws_ec2_transit_gateway_vpc_attachment.egress.id
    "shared" = data.aws_ec2_transit_gateway_vpc_attachment.shared.id
  }

  association_config_transformed = {
    "egress-to-rt-egress" = {
      transit_gateway_attachment_id = local.attachment_ids["egress"]
      route_table_key              = "egress"
    }
    "shared-to-rt-shared" = {
      transit_gateway_attachment_id = local.attachment_ids["shared"]
      route_table_key              = "shared"
    }
  }

  # ---------------------------------------------------------------------------
  # Propagations: spokes propagan a RT-Egress y RT-Shared
  # (En este ejemplo no hay spokes aún, se agregan cuando se attachan)
  # ---------------------------------------------------------------------------
  propagation_config_transformed = var.propagation_config

  # ---------------------------------------------------------------------------
  # Static Routes con IDs dinámicos
  # ---------------------------------------------------------------------------
  static_route_config_transformed = {
    "spoke-default-to-egress" = {
      route_table_key               = "spoke"
      destination_cidr_block        = "0.0.0.0/0"
      transit_gateway_attachment_id = local.attachment_ids["egress"]
      blackhole                     = false
    }
    "spoke-shared-svc" = {
      route_table_key               = "spoke"
      destination_cidr_block        = "10.100.0.0/16"
      transit_gateway_attachment_id = local.attachment_ids["shared"]
      blackhole                     = false
    }
  }
}
