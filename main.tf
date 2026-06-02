# =============================================================================
# Recursos Principales del Módulo - TGW Routing
# PC-IAC-010: For_Each y Control de Recursos
# PC-IAC-023: Diseño Monolítico Funcional (Responsabilidad Única)
# =============================================================================

# -----------------------------------------------------------------------------
# Transit Gateway Route Tables
# -----------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table" "this" {
  for_each = local.route_tables_processed

  provider           = aws.project
  transit_gateway_id = var.transit_gateway_id

  tags = each.value.tags

  lifecycle {
    prevent_destroy = false
  }
}

# -----------------------------------------------------------------------------
# Route Table Associations
# "Este attachment usa ESTA tabla para decidir a dónde va su tráfico"
# -----------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  for_each = var.association_config

  provider = aws.project

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
}

# -----------------------------------------------------------------------------
# Route Table Propagations
# "Anuncia el CIDR de este attachment en ESTA tabla (para tráfico de retorno)"
# -----------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  for_each = var.propagation_config

  provider = aws.project

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
}

# -----------------------------------------------------------------------------
# Static Routes
# Rutas estáticas: 0.0.0.0/0 → Egress, 10.100.0.0/16 → Shared, Blackholes
# -----------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = var.static_route_config

  provider = aws.project

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this[each.value.route_table_key].id
  destination_cidr_block         = each.value.destination_cidr_block

  # Si es blackhole, no se especifica attachment
  transit_gateway_attachment_id = each.value.blackhole ? null : each.value.transit_gateway_attachment_id
  blackhole                     = each.value.blackhole
}
