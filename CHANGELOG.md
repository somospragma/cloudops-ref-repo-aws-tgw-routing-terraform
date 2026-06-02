# Changelog

Todos los cambios notables de este módulo serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-05-19

### Added
- Creación inicial del módulo de TGW Routing
- Soporte para múltiples Route Tables mediante `for_each`
- Associations: vincula attachments a route tables
- Propagations: anuncia CIDRs en route tables
- Static Routes: rutas estáticas y blackholes
- Tags de gobernanza según PC-IAC-004
- Ejemplo funcional en `sample/` siguiendo PC-IAC-026
