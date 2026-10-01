#!/usr/bin/env bash
set -euo pipefail

dnf clean all
rm -rf /var/cache/dnf
rm -rf /tmp/*
rm -rf /var/tmp/*

# Reset machine-id
> /etc/machine-id

dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null || true
rm -f /EMPTY
sync
