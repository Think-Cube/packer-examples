#!/usr/bin/env bash
set -euo pipefail

dnf update -y
dnf install -y \
  curl \
  git \
  jq \
  unzip \
  vim \
  wget \
  kernel-devel \
  kernel-headers \
  dkms \
  gcc \
  make \
  perl

systemctl enable sshd
