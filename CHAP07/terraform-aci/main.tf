# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.46.0"
    }
  }

  backend "azurerm" {
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "acidemobook" {
  name     = "demobook"
  location = "westeurope"
}

variable "imageversion" {
  description = "Tag of the image to deploy"
}

variable "dockerhub-username" {
  description = "DockerHub username"
}


resource "azurerm_container_group" "aci-myapp" {
  name                = "aci-app"
  location            = "westus2"
  resource_group_name = azurerm_resource_group.acidemobook.name
  ip_address_type     = "public"
  dns_name_label      = "myapp-demo"
  os_type             = "linux"
  container {
    name   = "myappdemo"
    image  = "${var.dockerhub-username}/demobook:${var.imageversion}"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }

  }



}
