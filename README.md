# Exercise 1.2 — Break Apart the Monolith

Repositorio correspondiente al ejercicio 1.2 del curso:

Optimizaciones y Desempeño — Cloud Deployment Automation

---

## Objetivo

Reestructurar una configuración Terraform monolítica aplicando buenas prácticas de Infrastructure as Code mediante:
- separación de archivos
- parametrización
- uso de variables
- uso de locals
- outputs
- archivos tfvars
- validaciones

Sin modificar la funcionalidad original de la infraestructura.

---


## Estructura del proyecto

oyd-exercise-1-2/
├── provider.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── dev.tfvars
├── prod.tfvars
├── README.md
└── Exervise 1-2.md

--

## Autor

Sergio Geovany Garcia Smith
Carnet: 25008130