terraform {
  required_version = ">= 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  # Connects to default Docker daemon (npipe:////./pipe/docker_engine on Windows or unix:///var/run/docker.sock on Linux)
}

# ==========================================
# Network & Volume
# ==========================================
resource "docker_network" "tamagochi_network" {
  name   = "tamagochi-network-tf"
  driver = "bridge"
}

resource "docker_volume" "db_data" {
  name = "tamagochi-db-data-tf"
}

# ==========================================
# Docker Images
# ==========================================
resource "docker_image" "database" {
  name         = var.database_image
  keep_locally = true
}

resource "docker_image" "backend" {
  name         = var.backend_image
  keep_locally = true
}

resource "docker_image" "frontend" {
  name         = var.frontend_image
  keep_locally = true
}

# ==========================================
# Containers
# ==========================================
# 1. PostgreSQL Database
resource "docker_container" "database" {
  name  = "tamagochi-db-tf"
  image = docker_image.database.image_id

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  volumes {
    volume_name    = docker_volume.db_data.name
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = 5432
    external = var.db_port
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name    = docker_network.tamagochi_network.name
    aliases = ["database"]
  }

  restart = "unless-stopped"

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval     = "5s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }
  wait         = true
  wait_timeout = 60
}

# 2. Spring Boot Backend
resource "docker_container" "backend" {
  name  = "tamagochi-back-tf"
  image = docker_image.backend.image_id

  env = [
    "SERVER_PORT=8080",
    "DB_HOST=database",
    "DB_PORT=5432",
    "DB_NAME=${var.db_name}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "PET_DECAY_INTERVAL=${var.pet_decay_interval}"
  ]

  ports {
    internal = 8080
    external = var.backend_port
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name    = docker_network.tamagochi_network.name
    aliases = ["backend"]
  }

  depends_on = [
    docker_container.database
  ]

  restart = "unless-stopped"

  healthcheck {
    test         = ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:8080/actuator/health"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "30s"
  }
  wait         = true
  wait_timeout = 90
}

# 3. Angular Frontend (Nginx reverse proxy)
resource "docker_container" "frontend" {
  name  = "tamagochi-front-tf"
  image = docker_image.frontend.image_id

  env = [
    "BACKEND_URL=http://backend:8080"
  ]

  ports {
    internal = 8080
    external = var.frontend_port
    ip       = "127.0.0.1"
  }

  networks_advanced {
    name    = docker_network.tamagochi_network.name
    aliases = ["frontend"]
  }

  depends_on = [
    docker_container.backend
  ]

  restart = "unless-stopped"
}
