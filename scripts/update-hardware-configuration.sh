#!/usr/bin/env bash

host=${1:-$(cat /proc/sys/kernel/hostname)}
nixos-generate-config --show-hardware-config --no-filesystems 2> /dev/null > "hosts/$host/hardware-configuration.nix"
