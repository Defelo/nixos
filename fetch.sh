#!/usr/bin/env bash

set -euo pipefail

path=$(nix eval --raw .#nixosConfigurations."$(cat /proc/sys/kernel/hostname)".config.system.build.toplevel.outPath)
nix-store -r "$path"
