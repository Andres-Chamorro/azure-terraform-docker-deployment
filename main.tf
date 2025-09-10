terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # host = "unix:///var/run/docker.sock"  # Para Linux/Mac
  host = "npipe:////./pipe/docker_engine"  # Windows
}

# Crear una red Docker
resource "docker_network" "nginx_network" {
  name = "nginx_network"
}

# Descargar la imagen de Nginx
resource "docker_image" "nginx_image" {
  name = "nginx:latest"
  keep_locally = true
}

# Crear el contenedor de Nginx
resource "docker_container" "nginx_container" {
  name  = "nginx_terraform"
  image = docker_image.nginx_image.name   # <- cambiar latest por name
  networks_advanced {
    name = docker_network.nginx_network.name
  }
  ports {
    internal = 80
    external = 8080
  }
}

