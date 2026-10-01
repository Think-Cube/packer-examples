packer {
  required_version = ">= 1.11.0"
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1.0"
    }
  }
}

variable "vm_name" {
  type    = string
  default = "debian-12-amd64"
}

variable "disk_size" {
  type    = number
  default = 40960
}

variable "memory" {
  type    = number
  default = 2048
}

variable "cpus" {
  type    = number
  default = 2
}

variable "headless" {
  type    = bool
  default = true
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type      = string
  sensitive = true
  default   = "packer"
}

source "vmware-iso" "debian" {
  vm_name       = var.vm_name
  disk_size     = var.disk_size
  headless      = var.headless
  guest_os_type = "debian12-64"

  iso_urls = [
    "https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.11.0-amd64-netinst.iso"
  ]
  iso_checksum = "sha256:36b2b9cc56e39e7f6a4d36adc0f76a70ee7b9e50e8f5d41e21a29c7ab29d1d43"

  http_directory = "http"

  boot_wait = "5s"
  boot_command = [
    "<esc><wait>",
    "auto url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "hostname=packer ",
    "domain=local ",
    "<enter><wait>"
  ]

  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_port         = 22
  ssh_timeout      = "60m"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  memory               = var.memory
  cpus                 = var.cpus
  version              = "21"
  network_adapter_type = "vmxnet3"
  disk_adapter_type    = "pvscsi"

  output_directory = "output-${var.vm_name}"
}

build {
  name    = "debian-12-vmware"
  sources = ["source.vmware-iso.debian"]

  provisioner "shell" {
    execute_command = "echo '${var.ssh_password}' | {{.Vars}} sudo -S -E bash '{{.Path}}'"
    scripts = [
      "scripts/setup.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
