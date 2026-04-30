# Exercise 1.2 — Break Apart the Monolith

Curso: Optimizaciones y Desempeño — Cloud Deployment Automation  
Sesión: 1 — 23 de abril de 2026  

---

# Repositorio
oyd-exercise-1-2

# Objetivo del ejercicio
Reestructurar una configuración Terraform monolítica en una estructura organizada y reutilizable utilizando:

- separación de responsabilidades
- variables
- locals
- outputs
- tfvars
- validaciones

Sin agregar nueva infraestructura ni modificar la funcionalidad existente.

# Estructura final del proyecto
oyd-exercise-1-2/
├── provider.tf
├── variables.tf
├── locals.tf
├── main.tf
├── outputs.tf
├── dev.tfvars
├── prod.tfvars

# Task 1 — Separación de archivos
La configuración original contenía todos los bloques Terraform en un único archivo everything.tf.

La solución reorganizó la infraestructura separando cada responsabilidad en archivos independientes:

|Archivo	|Responsabilidad
|provider.tf	|Provider y configuración Terraform
|variables.tf	|Variables de entrada
|locals.tf	|Valores derivados
|main.tf	|Recursos
|outputs.tf	|Outputs
|dev.tfvars	|Variables para ambiente dev
|prod.tfvars	|Variables para ambiente prod

El archivo everything.tf fue eliminado al finalizar.

# Task 2 — Parametrización
## Archivo: variables.tf
variable "environment" {
  description = "Ambiente de despliegue"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment debe ser 'dev' o 'prod'."
  }
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "region" {
  description = "Región AWS"
  type        = string
  default     = "us-east-1"
}

variable "bucket_suffix" {
  description = "Sufijo del bucket S3"
  type        = string
}

## Explicación
Todas las variables:

- poseen description
- tienen type
- eliminan valores hardcodeados

La variable environment incluye un bloque validation que restringe los valores permitidos a:

- dev
- prod

# Task 3 — Construcción del bucket name mediante locals
## Archivo: locals.tf
locals {
  bucket_name = "${var.project_name}-${var.environment}-${var.bucket_suffix}"
}

## Explicacion
El nombre del bucket se construye dinámicamente utilizando variables.

Esto permite:

reutilización
mantenibilidad
centralización de lógica

El recurso en main.tf utiliza:
bucket = local.bucket_name

# Task 4 — tfvars por ambiente
## Archivo: dev.tfvars
environment   = "dev"
project_name  = "myapp"
region        = "us-east-1"
bucket_suffix = "uploads"

## Archivo: prod.tfvars
environment   = "prod"
project_name  = "enterpriseapp"
region        = "us-east-2"
bucket_suffix = "assets"

## Explicación
Los archivos .tfvars permiten reutilizar la misma infraestructura con diferentes valores por ambiente.

Se modificaron más de dos variables entre:

- dev
- prod

cumpliendo los requisitos del ejercicio.

# Task 5 — Verificación
## Comandos ejecutados
terraform init
terraform validate
terraform plan -var-file=dev.tfvars

## Salida de terraform validate

Success! The configuration is valid.

## Salida relevante de terraform plan
 #aws_s3_bucket.main will be created
  + resource "aws_s3_bucket" "main" {
      + bucket = "myapp-dev-uploads"

      + tags = {
          + "Environment" = "dev"
          + "ManagedBy"   = "terraform"
          + "Project"     = "myapp"
        }
    }

## Verificación del nombre del bucket
La expresión:
"${var.project_name}-${var.environment}-${var.bucket_suffix}"

con valores:
project_name  = "myapp"
environment   = "dev"
bucket_suffix = "uploads"

produce correctamente:

myapp-dev-uploads

## Validación del bloque validation
### Comando ejecutado
terraform plan -var="environment=qa"

### Resultado
Error: Invalid value for variable

environment debe ser 'dev' o 'prod'.

### Explicación
Terraform rechazó correctamente un valor inválido para environment gracias al bloque validation.

Esto permite:

- prevenir errores temprano
- imponer contratos de configuración
- mejorar seguridad y consistencia