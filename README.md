# PackerExamples

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Packer](https://img.shields.io/badge/Packer-%3E%3D1.11.0-blue?logo=packer)](https://developer.hashicorp.com/packer)
[![Azure](https://img.shields.io/badge/Azure-supported-0078D4?logo=microsoftazure)](azure/)
[![VirtualBox](https://img.shields.io/badge/VirtualBox-%3E%3D7.0-183A61?logo=virtualbox)](virtualbox/)
[![VMware](https://img.shields.io/badge/VMware_Workstation-%3E%3D17.0-607078?logo=vmware)](vmware/)

A collection of professional [HashiCorp Packer](https://www.packer.io/) templates written in HCL2 for building machine images across multiple platforms. All templates follow current best practices and target modern, supported OS versions.

## Platforms & Templates

### Microsoft Azure

| Template | OS | Publisher | SKU |
|---|---|---|---|
| [ubuntu-24.04](azure/ubuntu-24.04) | Ubuntu 24.04 LTS (Noble) | Canonical | `22_04-lts-gen2` |
| [debian-12](azure/debian-12) | Debian 12 (Bookworm) | Debian | `12` |
| [windows-server-2025](azure/windows-server-2025) | Windows Server 2025 Datacenter | MicrosoftWindowsServer | `2025-datacenter-g2` |

### VirtualBox

| Template | OS | ISO |
|---|---|---|
| [ubuntu-24.04](virtualbox/ubuntu-24.04) | Ubuntu 24.04.2 LTS | live-server, autoinstall |
| [debian-12](virtualbox/debian-12) | Debian 12.11 Bookworm | netinst, preseed |
| [rocky-9](virtualbox/rocky-9) | Rocky Linux 9.5 | minimal, kickstart |

### VMware Workstation

| Template | OS | ISO |
|---|---|---|
| [ubuntu-24.04](vmware/ubuntu-24.04) | Ubuntu 24.04.2 LTS | live-server, autoinstall |
| [debian-12](vmware/debian-12) | Debian 12.11 Bookworm | netinst, preseed |
| [rocky-9](vmware/rocky-9) | Rocky Linux 9.5 | minimal, kickstart |

## Requirements

| Tool | Minimum version |
|---|---|
| [Packer](https://developer.hashicorp.com/packer/install) | 1.11.0 |
| [VirtualBox](https://www.virtualbox.org/) *(VirtualBox templates)* | 7.0 |
| [VMware Workstation Pro](https://www.vmware.com/products/workstation-pro.html) *(VMware templates)* | 17.0 |
| Azure subscription *(Azure templates)* | — |

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/Think-Cube/PackerExamples.git
cd PackerExamples
```

### 2. Initialize the plugins

```bash
cd <platform>/<template>
packer init .
```

### 3. Configure variables

Copy the example file and fill in your values:

```bash
cp variables.pkrvars.hcl.example variables.pkrvars.hcl
```

For Azure templates you can also export environment variables:

```bash
export ARM_CLIENT_ID="<client-id>"
export ARM_CLIENT_SECRET="<client-secret>"
export ARM_SUBSCRIPTION_ID="<subscription-id>"
export ARM_TENANT_ID="<tenant-id>"
```

### 4. Validate and build

```bash
packer validate .
packer build .
```

With a var file:

```bash
packer build -var-file="variables.pkrvars.hcl" .
```

## Azure — Service Principal Setup

```bash
az ad sp create-for-rbac \
  --name "packer-sp" \
  --role Contributor \
  --scopes /subscriptions/<subscription-id>
```

The output provides `appId` → `ARM_CLIENT_ID`, `password` → `ARM_CLIENT_SECRET`, `tenant` → `ARM_TENANT_ID`.

The resource group referenced in `resource_group_name` must exist before running a build:

```bash
az group create --name packer-images-rg --location "West Europe"
```

## Repository Structure

```
PackerExamples/
├── azure/
│   ├── ubuntu-24.04/          # Ubuntu 24.04 LTS managed image
│   ├── debian-12/             # Debian 12 Bookworm managed image
│   └── windows-server-2025/   # Windows Server 2025 managed image
├── virtualbox/
│   ├── ubuntu-24.04/          # Ubuntu 24.04 LTS VirtualBox image
│   ├── debian-12/             # Debian 12 Bookworm VirtualBox image
│   └── rocky-9/               # Rocky Linux 9 VirtualBox image
├── vmware/
│   ├── ubuntu-24.04/          # Ubuntu 24.04 LTS VMware image
│   ├── debian-12/             # Debian 12 Bookworm VMware image
│   └── rocky-9/               # Rocky Linux 9 VMware image
└── .github/workflows/         # CI — packer validate on every push/PR
```

Each template directory contains:

```
<template>/
├── <name>.pkr.hcl             # Main Packer template (HCL2)
├── variables.pkrvars.hcl.example
├── scripts/                   # Shell / PowerShell provisioners
└── http/                      # Autoinstall / preseed / kickstart files
```

## Contributing

Pull requests are welcome. Please open an issue first to discuss significant changes. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

[MIT](LICENSE) © Think-Cube
