variable "db_name" {
  type        = string
  description = "PostgreSQL database name"
  default     = "tamagochi"
}

variable "db_user" {
  type        = string
  description = "PostgreSQL database username"
  default     = "tamagochi"
}

variable "db_password" {
  type        = string
  description = "PostgreSQL database password"
  default     = "tamagochi"
  sensitive   = true
}

variable "db_port" {
  type        = number
  description = "Exposed port for PostgreSQL"
  default     = 5432
}

variable "backend_port" {
  type        = number
  description = "Exposed port for Spring Boot API"
  default     = 8080
}

variable "frontend_port" {
  type        = number
  description = "Exposed port for Angular frontend"
  default     = 80
}

variable "pet_decay_interval" {
  type        = string
  description = "Interval for pet decay status updates"
  default     = "10s"
}

variable "backend_image" {
  type        = string
  description = "Docker image for Spring Boot backend"
  default     = "ghcr.io/skywishky/cappoensixdellelys-back:latest"
}

variable "frontend_image" {
  type        = string
  description = "Docker image for Angular frontend"
  default     = "ghcr.io/skywishky/cappoensixdellelys-front:latest"
}
