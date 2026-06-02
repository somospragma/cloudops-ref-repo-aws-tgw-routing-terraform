# =============================================================================
# Data Sources del Ejemplo
# PC-IAC-011: Data Sources en el Root para obtener IDs dinámicos
# =============================================================================

# Obtener Transit Gateway
data "aws_ec2_transit_gateway" "selected" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-tgw-main"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Obtener VPC Attachment de Egress
data "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-tgw-att-egress"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Obtener VPC Attachment de Shared Services
data "aws_ec2_transit_gateway_vpc_attachment" "shared" {
  provider = aws.principal

  filter {
    name   = "tag:Name"
    values = ["${var.client}-${var.project}-${var.environment}-tgw-att-shared"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
