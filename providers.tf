# =============================================================================
# Configuración de Providers
# PC-IAC-005: El provider se inyecta desde el Módulo Raíz (IaC Root)
# =============================================================================

# El provider AWS se inyecta desde el módulo consumidor mediante:
#   providers = {
#     aws.project = aws.principal
#   }
