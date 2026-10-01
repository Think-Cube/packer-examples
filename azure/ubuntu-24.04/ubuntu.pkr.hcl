packer {
  required_version = ">= 1.11.0"
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2.0"
    }
  }
}

variable "client_id" {
  type      = string
  sensitive = true
  default   = env("ARM_CLIENT_ID")
}

variable "client_secret" {
  type      = string
  sensitive = true
  default   = env("ARM_CLIENT_SECRET")
}

variable "subscription_id" {
  type    = string
  default = env("ARM_SUBSCRIPTION_ID")
}

variable "tenant_id" {
  type    = string
  default = env("ARM_TENANT_ID")
}

variable "resource_group_name" {
  type    = string
  default = "packer-images-rg"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "vm_size" {
  type    = string
  default = "Standard_B2s"
}

variable "image_name" {
  type    = string
  default = "ubuntu-2404-lts"
}

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

source "azure-arm" "ubuntu" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  managed_image_resource_group_name = var.resource_group_name
  managed_image_name                = "${var.image_name}-${local.timestamp}"

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "ubuntu-24_04-lts"
  image_sku       = "server"

  location = var.location
  vm_size  = var.vm_size

  async_resourcegroup_delete = true

  azure_tags = {
    OS        = "Ubuntu"
    OSVersion = "24.04 LTS"
    Builder   = "Packer"
    BuildDate = local.timestamp
  }
}

build {
  name    = "ubuntu-2404"
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; sudo bash -c '{{ .Vars }} {{ .Path }}'"
    script          = "scripts/provision.sh"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
