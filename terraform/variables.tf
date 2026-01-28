variable "sql_password" {
  description = "SQL Admin Password (from GitHub Secrets)"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "dr_location" {
  description = "Disaster recovery region"
  type        = string
  default     = "West US"
}
