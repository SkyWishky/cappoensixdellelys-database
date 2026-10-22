output "frontend_url" {
  description = "Local URL to access Angular frontend"
  value       = "http://localhost:${var.frontend_port}"
}

output "backend_api_url" {
  description = "Local URL to access Spring Boot API"
  value       = "http://localhost:${var.backend_port}"
}

output "backend_health_url" {
  description = "Local URL to check backend health status"
  value       = "http://localhost:${var.backend_port}/actuator/health"
}

output "database_endpoint" {
  description = "PostgreSQL local connection endpoint"
  value       = "localhost:${var.db_port}"
}
