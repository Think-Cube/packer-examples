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
  default = "Standard_D2s_v3"
}

variable "image_name" {
  type    = string
  default = "windows-server-2025-datacenter"
}

locals {
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())
}

source "azure-arm" "windows" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  managed_image_resource_group_name = var.resource_group_name
  managed_image_name                = "${var.image_name}-${local.timestamp}"

  os_type         = "Windows"
  image_publisher = "MicrosoftWindowsServer"
  image_offer     = "WindowsServer"
  image_sku       = "2025-datacenter-g2"

  location = var.location
  vm_size  = var.vm_size

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "15m"
  winrm_username = "packer"

  async_resourcegroup_delete = true

  azure_tags = {
    OS        = "Windows Server"
    OSVersion = "2025 Datacenter"
    Builder   = "Packer"
    BuildDate = local.timestamp
  }
}

build {
  name    = "windows-server-2025"
  sources = ["source.azure-arm.windows"]

  provisioner "powershell" {
    script = "scripts/provision.ps1"
  }

  provisioner "windows-restart" {
    restart_timeout = "15m"
  }

  provisioner "powershell" {
    script = "scripts/cleanup.ps1"
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
