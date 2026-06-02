# =============================================================================
# Valores Locales y Transformaciones
# PC-IAC-003: Nomenclatura Estándar
# PC-IAC-012: Estructuras de Datos y Reutilización en Locals
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Prefijo de Gobernanza
  # ---------------------------------------------------------------------------
  governance_prefix = "${var.client}-${var.project}-${var.environment}"

  # ---------------------------------------------------------------------------
  # Tags Base del Módulo
  # PC-IAC-004: Etiquetas Obligatorias
  # ---------------------------------------------------------------------------
  base_module_tags = {
    "managed-by" = "terraform"
    "module"     = "tgw-routing"
  }

  # ---------------------------------------------------------------------------
  # Route Tables Procesadas
  # ---------------------------------------------------------------------------
  route_tables_processed = {
    for key, config in var.route_table_config : key => {
      name = config.name
      tags = merge(
        { Name = config.name },
        local.base_module_tags,
        config.additional_tags
      )
    }
  }
}
