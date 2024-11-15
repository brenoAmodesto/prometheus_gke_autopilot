variable "project_id" {
  description = "ID do projeto no Google Cloud"
}

variable "service_account_email" {
  description = "E-mail da Service Account"
}

variable "bucket_name" {
  description = "Nome do bucket do Velero"
}

variable "alert_email_address" {
  description = "Endereço de e-mail para receber alertas do Prometheus"
  type        = string
}
