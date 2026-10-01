packer {
  required_version = ">= 1.11.0"
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1.0"
    }
  }
}

variable "vm_name" {
  type    = string
  default = "ubuntu-24.04-amd64"
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

source "virtualbox-iso" "ubuntu" {
  vm_name      = var.vm_name
  disk_size    = var.disk_size
  headless     = var.headless
  guest_os_type = "Ubuntu_64"

  iso_urls = [
    "https://releases.ubuntu.com/24.04.5/ubuntu-24.04.5-live-server-amd64.iso"
  ]
  iso_checksum = "sha256:97f3d7ffb032c3eb3b23d2c8be9cc76e60c2c1f2c0146ba5ba9fe01cafae0fd8"

  http_directory = "http"

  boot_wait = "5s"
  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter><wait5>",
    "initrd /casper/initrd<enter><wait5>",
    "boot<enter><wait30>"
  ]

  ssh_username    = var.ssh_username
  ssh_password    = var.ssh_password
  ssh_port        = 22
  ssh_timeout     = "60m"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "${var.memory}"],
    ["modifyvm", "{{.Name}}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
  ]

  output_directory = "output-${var.vm_name}"
}

build {
  name    = "ubuntu-2404-virtualbox"
  sources = ["source.virtualbox-iso.ubuntu"]

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
