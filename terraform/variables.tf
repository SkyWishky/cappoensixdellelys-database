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
  default     = 4200
}

variable "pet_decay_interval" {
  type        = number
  description = "Pet decay interval in milliseconds"
  default     = 10000
}

variable "database_image" {
  type        = string
  description = "Docker image for PostgreSQL with the schema and seed data"
  default     = "ghcr.io/skywishky/cappoensixdellelys-database:latest"
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
