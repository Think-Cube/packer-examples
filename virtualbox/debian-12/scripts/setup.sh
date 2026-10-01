#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y
apt-get install -y \
  build-essential \
  curl \
  dkms \
  git \
  jq \
  linux-headers-$(uname -r) \
  unzip \
  vim \
  wget

truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id
