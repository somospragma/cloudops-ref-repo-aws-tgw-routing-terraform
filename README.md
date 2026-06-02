# TGW Routing Module

Módulo de Terraform para la creación y gestión de TGW Route Tables, Associations, Propagations y Static Routes siguiendo las reglas de gobernanza PC-IAC.

## Descripción

Este módulo gestiona todo el enrutamiento DENTRO del Transit Gateway:
- **Route Tables**: Crea tablas de enrutamiento (RT-Spoke, RT-Egress, RT-Shared)
- **Associations**: Vincula attachments a route tables ("este attachment usa esta tabla")
- **Propagations**: Anuncia CIDRs de attachments en route tables (tráfico de retorno)
- **Static Routes**: Rutas estáticas (default route, blackholes, rutas a shared services)

## Uso

```hcl
module "tgw_routing" {
  source = "git::https://github.com/org/tgw-routing-module.git?ref=v1.0.0"

  providers = {
    aws.project = aws.principal
  }

  client      = var.client
  project     = var.project
  environment = var.environment

  transit_gateway_id  = module.transit_gateway.transit_gateway_ids["main"]
  route_table_config  = local.route_table_config_transformed
  association_config  = local.association_config_transformed
  propagation_config  = local.propagation_config_transformed
  static_route_config = local.static_route_config_transformed
}
```

## Inputs

| Nombre | Descripción | Tipo | Requerido |
|--------|-------------|------|-----------|
| `client` | Nombre del cliente | `string` | Sí |
| `project` | Nombre del proyecto | `string` | Sí |
| `environment` | Entorno de despliegue | `string` | Sí |
| `transit_gateway_id` | ID del Transit Gateway | `string` | Sí |
| `route_table_config` | Mapa de Route Tables a crear | `map(object)` | No |
| `association_config` | Mapa de asociaciones attachment→RT | `map(object)` | No |
| `propagation_config` | Mapa de propagaciones attachment→RT | `map(object)` | No |
| `static_route_config` | Mapa de rutas estáticas | `map(object)` | No |

## Outputs

| Nombre | Descripción |
|--------|-------------|
| `route_table_ids` | Mapa de IDs de Route Tables |
| `route_table_arns` | Mapa de ARNs de Route Tables |
| `route_table_ids_list` | Lista de IDs |
| `association_ids` | Mapa de IDs de asociaciones |
| `propagation_ids` | Mapa de IDs de propagaciones |

## Ejemplo de Diseño Hub-Spoke

```hcl
# Route Tables
route_table_config = {
  "spoke"  = { name = "pragma-net-dev-tgw-rt-spoke" }
  "egress" = { name = "pragma-net-dev-tgw-rt-egress" }
  "shared" = { name = "pragma-net-dev-tgw-rt-shared" }
}

# Associations
association_config = {
  "egress-to-rt-egress" = {
    transit_gateway_attachment_id = "tgw-attach-egress-id"
    route_table_key              = "egress"
  }
  "shared-to-rt-shared" = {
    transit_gateway_attachment_id = "tgw-attach-shared-id"
    route_table_key              = "shared"
  }
  "app-a-to-rt-spoke" = {
    transit_gateway_attachment_id = "tgw-attach-app-a-id"
    route_table_key              = "spoke"
  }
}

# Propagations (spokes propagan a RT-Egress y RT-Shared para retorno)
propagation_config = {
  "app-a-to-egress" = {
    transit_gateway_attachment_id = "tgw-attach-app-a-id"
    route_table_key              = "egress"
  }
  "app-a-to-shared" = {
    transit_gateway_attachment_id = "tgw-attach-app-a-id"
    route_table_key              = "shared"
  }
}

# Static Routes
static_route_config = {
  "spoke-default" = {
    route_table_key               = "spoke"
    destination_cidr_block        = "0.0.0.0/0"
    transit_gateway_attachment_id = "tgw-attach-egress-id"
  }
  "spoke-to-shared" = {
    route_table_key               = "spoke"
    destination_cidr_block        = "10.100.0.0/16"
    transit_gateway_attachment_id = "tgw-attach-shared-id"
  }
  "spoke-blackhole" = {
    route_table_key        = "spoke"
    destination_cidr_block = "10.0.0.0/8"
    blackhole              = true
  }
}
```

## Cumplimiento de Reglas PC-IAC

| Regla | Implementación |
|-------|----------------|
| PC-IAC-001 | Estructura completa (10 raíz + 8 sample/) |
| PC-IAC-002 | Variables con type, description, validation |
| PC-IAC-003 | Nomenclatura construida en Root |
| PC-IAC-004 | Tags con merge (Name + base + additional) |
| PC-IAC-005 | Alias aws.project |
| PC-IAC-010 | for_each con map |
| PC-IAC-023 | Solo recursos de routing del TGW |

## Recursos Creados

- `aws_ec2_transit_gateway_route_table`
- `aws_ec2_transit_gateway_route_table_association`
- `aws_ec2_transit_gateway_route_table_propagation`
- `aws_ec2_transit_gateway_route`

## Referencias

- [TGW Route Tables](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-route-tables.html)
- [Centralized Egress](https://docs.aws.amazon.com/whitepapers/latest/building-scalable-secure-multi-vpc-network-infrastructure/using-nat-gateway-for-centralized-egress.html)
