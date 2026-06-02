# =============================================================================
# Configuración de Providers para el Ejemplo
# PC-IAC-005: Provider principal con alias, assume_role y default_tags
# =============================================================================

provider "aws" {
  region = var.region
  alias  = "principal"

  assume_role {
    role_arn = var.deploy_role_arn
  }

  default_tags {
    tags = var.common_tags
  }
}
