# Ejemplo de Uso del Módulo TGW Routing

Este ejemplo demuestra cómo crear 3 TGW Route Tables (RT-Spoke, RT-Egress, RT-Shared), asociar attachments y configurar rutas estáticas para networking centralizado.

## Pre-requisitos

- Transit Gateway creado y disponible
- VPC Attachments de Egress y Shared Services creados

## Ejecución

```bash
cd sample/
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Flujo de Datos (PC-IAC-026)

```
terraform.tfvars → variables.tf → data.tf → locals.tf → main.tf → ../
```
