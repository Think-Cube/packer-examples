#!/usr/bin/env bash
set -euo pipefail

dnf update -y
dnf install -y \
  curl \
  git \
  jq \
  open-vm-tools \
  unzip \
  vim \
  wget \
  gcc \
  make \
  perl

systemctl enable sshd
systemctl enable vmtoolsd
