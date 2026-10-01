#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*
rm -rf /var/tmp/*

dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null || true
rm -f /EMPTY
sync
