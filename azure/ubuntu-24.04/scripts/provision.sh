#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y
apt-get install -y \
  curl \
  git \
  jq \
  unzip \
  vim \
  wget \
  ca-certificates \
  gnupg \
  lsb-release \
  apt-transport-https

# Azure Linux Agent — ensure latest version
apt-get install -y walinuxagent

# Deprovision agent at end of build
/usr/sbin/waagent -force -deprovision+user
