# =============================================================================
# Variables del Ejemplo
# =============================================================================

variable "client" {
  description = "Nombre del cliente."
  type        = string
}

variable "project" {
  description = "Nombre del proyecto."
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue."
  type        = string
}

variable "region" {
  description = "Región AWS."
  type        = string
  default     = "us-east-1"
}

variable "deploy_role_arn" {
  description = "ARN del rol para asumir."
  type        = string
}

variable "common_tags" {
  description = "Tags transversales."
  type        = map(string)
}

variable "transit_gateway_id" {
  description = "ID del Transit Gateway."
  type        = string
}

variable "route_table_config" {
  description = "Configuración de Route Tables."
  type = map(object({
    additional_tags = optional(map(string), {})
  }))
}

variable "association_config" {
  description = "Configuración de asociaciones."
  type = map(object({
    transit_gateway_attachment_id = string
    route_table_key              = string
  }))
}

variable "propagation_config" {
  description = "Configuración de propagaciones."
  type = map(object({
    transit_gateway_attachment_id = string
    route_table_key              = string
  }))
  default = {}
}

variable "static_route_config" {
  description = "Configuración de rutas estáticas."
  type = map(object({
    route_table_key                = string
    destination_cidr_block         = string
    transit_gateway_attachment_id  = optional(string, null)
    blackhole                      = optional(bool, false)
  }))
}
