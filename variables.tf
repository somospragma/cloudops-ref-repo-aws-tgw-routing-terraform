# =============================================================================
# Variables de Entrada del Módulo
# PC-IAC-002: Variables Obligatorias y Buenas Prácticas de Declaración
# PC-IAC-009: Tipos de Datos, Conversiones y Lógica en Locals
# =============================================================================

# -----------------------------------------------------------------------------
# Variables de Gobernanza (Obligatorias)
# -----------------------------------------------------------------------------

variable "client" {
  description = "Nombre del cliente o unidad de negocio."
  type        = string

  validation {
    condition     = length(var.client) > 0 && length(var.client) <= 10
    error_message = "La variable 'client' debe tener entre 1 y 10 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.client))
    error_message = "La variable 'client' solo puede contener letras minúsculas y números."
  }
}

variable "project" {
  description = "Nombre del proyecto."
  type        = string

  validation {
    condition     = length(var.project) > 0 && length(var.project) <= 15
    error_message = "La variable 'project' debe tener entre 1 y 15 caracteres."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.project))
    error_message = "La variable 'project' solo puede contener letras minúsculas y números."
  }
}

variable "environment" {
  description = "Entorno de despliegue (dev, qa, pdn)."
  type        = string

  validation {
    condition     = contains(["dev", "qa", "pdn", "stg", "uat", "prod"], var.environment)
    error_message = "La variable 'environment' debe ser uno de: dev, qa, pdn, stg, uat, prod."
  }
}

# -----------------------------------------------------------------------------
# Transit Gateway ID
# -----------------------------------------------------------------------------

variable "transit_gateway_id" {
  description = "ID del Transit Gateway donde se crean las Route Tables."
  type        = string

  validation {
    condition     = length(var.transit_gateway_id) > 0
    error_message = "El transit_gateway_id es obligatorio."
  }
}

# -----------------------------------------------------------------------------
# Route Tables
# PC-IAC-002: map(object) para estabilidad con for_each
# -----------------------------------------------------------------------------

variable "route_table_config" {
  description = <<-EOT
    Mapa de configuración para TGW Route Tables.
    Cada clave representa una route table única (ej: "spoke", "egress", "shared").
    
    Atributos:
    - name: Nombre de la route table (construido en el Root con PC-IAC-025)
    - additional_tags: Tags adicionales
  EOT

  type = map(object({
    name            = string
    additional_tags = optional(map(string), {})
  }))

  default = {}

  validation {
    condition = alltrue([
      for key, config in var.route_table_config :
      length(config.name) > 0
    ])
    error_message = "Cada Route Table debe tener un nombre definido."
  }
}

# -----------------------------------------------------------------------------
# Associations (attachment → route table)
# -----------------------------------------------------------------------------

variable "association_config" {
  description = <<-EOT
    Mapa de asociaciones: vincula un attachment a una route table.
    Cada attachment solo puede estar asociado a UNA route table.
    
    Atributos:
    - transit_gateway_attachment_id: ID del attachment a asociar
    - route_table_key: Clave de la route table en route_table_config
  EOT

  type = map(object({
    transit_gateway_attachment_id = string
    route_table_key              = string
  }))

  default = {}

  validation {
    condition = alltrue([
      for key, config in var.association_config :
      length(config.transit_gateway_attachment_id) > 0
    ])
    error_message = "Cada asociación debe tener un transit_gateway_attachment_id."
  }

  validation {
    condition = alltrue([
      for key, config in var.association_config :
      length(config.route_table_key) > 0
    ])
    error_message = "Cada asociación debe tener un route_table_key."
  }
}

# -----------------------------------------------------------------------------
# Propagations (attachment propaga rutas a una route table)
# -----------------------------------------------------------------------------

variable "propagation_config" {
  description = <<-EOT
    Mapa de propagaciones: un attachment anuncia su CIDR en una route table.
    Un attachment puede propagar a múltiples route tables.
    
    Atributos:
    - transit_gateway_attachment_id: ID del attachment que propaga
    - route_table_key: Clave de la route table donde se propaga
  EOT

  type = map(object({
    transit_gateway_attachment_id = string
    route_table_key              = string
  }))

  default = {}

  validation {
    condition = alltrue([
      for key, config in var.propagation_config :
      length(config.transit_gateway_attachment_id) > 0
    ])
    error_message = "Cada propagación debe tener un transit_gateway_attachment_id."
  }

  validation {
    condition = alltrue([
      for key, config in var.propagation_config :
      length(config.route_table_key) > 0
    ])
    error_message = "Cada propagación debe tener un route_table_key."
  }
}

# -----------------------------------------------------------------------------
# Static Routes
# -----------------------------------------------------------------------------

variable "static_route_config" {
  description = <<-EOT
    Mapa de rutas estáticas en las TGW Route Tables.
    
    Atributos:
    - route_table_key: Clave de la route table donde agregar la ruta
    - destination_cidr_block: CIDR destino (ej: "0.0.0.0/0", "10.100.0.0/16")
    - transit_gateway_attachment_id: ID del attachment destino (null para blackhole)
    - blackhole: Si true, el tráfico se descarta
  EOT

  type = map(object({
    route_table_key                = string
    destination_cidr_block         = string
    transit_gateway_attachment_id  = optional(string, null)
    blackhole                      = optional(bool, false)
  }))

  default = {}

  validation {
    condition = alltrue([
      for key, config in var.static_route_config :
      length(config.destination_cidr_block) > 0
    ])
    error_message = "Cada ruta estática debe tener un destination_cidr_block."
  }

  validation {
    condition = alltrue([
      for key, config in var.static_route_config :
      length(config.route_table_key) > 0
    ])
    error_message = "Cada ruta estática debe tener un route_table_key."
  }

  validation {
    condition = alltrue([
      for key, config in var.static_route_config :
      config.blackhole == true || config.transit_gateway_attachment_id != null
    ])
    error_message = "Cada ruta debe tener un transit_gateway_attachment_id o blackhole=true."
  }
}
