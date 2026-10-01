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
  default = "rocky-9-amd64"
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

source "vmware-iso" "rocky" {
  vm_name       = var.vm_name
  disk_size     = var.disk_size
  headless      = var.headless
  guest_os_type = "centos-64"

  iso_urls = [
    "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.5-x86_64-minimal.iso"
  ]
  iso_checksum = "sha256:1b8a3985b1a80e2fe0dcf09e65aae42f0e0fbc15c5be9e29a43a3e93d5ba5c62"

  http_directory = "http"

  boot_wait = "10s"
  boot_command = [
    "<tab><wait>",
    " inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"
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
  name    = "rocky-9-vmware"
  sources = ["source.vmware-iso.rocky"]

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
