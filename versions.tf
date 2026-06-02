# =============================================================================
# Requisitos de versión de Terraform y Providers
# PC-IAC-005: Configuración y Alias de Providers
# PC-IAC-006: Versiones y Estabilidad
# =============================================================================

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
      configuration_aliases = [aws.project]
    }
  }
}
