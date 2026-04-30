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