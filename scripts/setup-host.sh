#!/usr/bin/env bash

mkdir -p /persistent/data/{root,home/felix}/.config/sops/age/
cp -a keys.txt /persistent/data/root/.config/sops/age/
mv keys.txt /persistent/data/home/felix/.config/sops/age/

mkdir -p /persistent/cache/var/{log,lib/nixos}
mkdir -p /persistent/data/home/felix/.gnupg -m 700
chown -R 1000:100 /persistent/data/home/felix
