#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "usage: new-host <hostname> [<root> [<crypt-name>]]"
    exit 1
fi

host=$1
root="${2:-/mnt}"
crypt="${3:-root}"

mkdir "hosts/$host"
update-hardware-configuration "$host"

system=$(nix-instantiate --eval -E "builtins.currentSystem")
echo "system: $system"
boot_uuid=$(findmnt -no UUID $root/boot)
echo "boot uuid: $boot_uuid"
crypt_uuid=$(lsblk -lsno UUID "/dev/mapper/$crypt" | head -2 | tail -1)
echo "crypt uuid: $crypt_uuid"

cat << EOF > "hosts/$host/default.nix"
_: {
  system = $system;

  partitions = {
    boot = "/dev/disk/by-uuid/$boot_uuid";
    crypt = "/dev/disk/by-uuid/$crypt_uuid";
  };

  extraConfig = {};
}
EOF

gpg --recv-keys 61303BBAD7D1BF74EFA44E3BE7FE2087E4380E64

age-keygen -o keys.txt
pub=$(age-keygen -y keys.txt)
sed -i "/^creation_rules:/i\  - &$host $pub" .sops.yaml
sed -i "\$s/ ]/, *$host ]/" .sops.yaml
sed -i "/^  - path_regex: secrets\/\.\+/i\  - path_regex: hosts/$host/secrets/.+$\n    key_groups:\n      - pgp: [ *defelo ]\n        age: [ *$host ]" .sops.yaml

pw=$(mkpasswd)
f=$(mktemp -u)
ssh-keygen -t ed25519 -C "" -P "" -f $f
mkdir -p hosts/$host/secrets
echo -e "user:\n  hashedPassword: $pw\nborg:\n  # $(cat $f.pub)\n  ssh_key: |" > hosts/$host/secrets/default.yml
sed 's/^/    /' $f >> hosts/$host/secrets/default.yml
echo -e "  encryption_key: $(pwgen -s 128 1)" >> hosts/$host/secrets/default.yml
sops -e -i hosts/$host/secrets/default.yml
rm $f $f.pub

mkdir -p hosts/$host/secrets/nm-connections
touch hosts/$host/secrets/nm-connections/.gitkeep
