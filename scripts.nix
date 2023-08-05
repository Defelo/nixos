pkgs: rec {
  update-hardware-configuration = pkgs.writeShellScriptBin "update-hardware-configuration" ''
    host=''${1:-$(cat /proc/sys/kernel/hostname)}
    nixos-generate-config --show-hardware-config --no-filesystems 2> /dev/null > "hosts/$host/hardware-configuration.nix"
  '';

  new-host = pkgs.writeShellScriptBin "new-host" ''
    host=''${1:-$(cat /proc/sys/kernel/hostname)}
    root="$2"
    crypt="''${3:-root}"

    mkdir "hosts/$host"
    ${update-hardware-configuration}/bin/update-hardware-configuration "$host"
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

    ${pkgs.age}/bin/age-keygen -o keys.txt
    pub=$(${pkgs.age}/bin/age-keygen -y keys.txt)
    sed -i "/^creation_rules:/i\  - &$host $pub" .sops.yaml
    sed -i "\$s/ ]/, *$host ]/" .sops.yaml
    sed -i "/^  - path_regex: secrets\/\.\+/i\  - path_regex: hosts/$host/secrets/.+$\n    key_groups:\n      - pgp: [ *defelo ]\n        age: [ *$host ]" .sops.yaml

    pw=$(${pkgs.mkpasswd}/bin/mkpasswd)
    f=$(mktemp -u)
    ssh-keygen -t ed25519 -C "" -P "" -f $f
    mkdir -p hosts/$host/secrets
    echo -e "user:\n  hashedPassword: $pw\nborg:\n  # $(cat $f.pub)\n  ssh_key: |" > hosts/$host/secrets/default.yml
    sed 's/^/    /' $f >> hosts/$host/secrets/default.yml
    echo -e "  encryption_key: $(${pkgs.pwgen}/bin/pwgen -s 128 1)" >> hosts/$host/secrets/default.yml
    ${pkgs.sops}/bin/sops -e -i hosts/$host/secrets/default.yml
    rm $f $f.pub

    mkdir -p hosts/$host/secrets/nm-connections
    touch hosts/$host/secrets/nm-connections/.gitkeep
  '';
}
