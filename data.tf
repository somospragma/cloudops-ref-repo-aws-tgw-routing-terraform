# =============================================================================
# Data Sources del Módulo
# PC-IAC-011: Data Sources deben estar en el Módulo Raíz (IaC Root)
# =============================================================================

# Los IDs de Transit Gateway y Attachments se reciben como variables de entrada.

data "aws_region" "current" {
  provider = aws.project
}

data "aws_caller_identity" "current" {
  provider = aws.project
}
