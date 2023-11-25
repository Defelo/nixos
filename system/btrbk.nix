{
  config,
  pkgs,
  lib,
  ...
}: let
  targets = {
    box = "u360850@u360850.your-storagebox.de:backups";
  };
  host = config.networking.hostName;
  withTarget = target: cmd:
    pkgs.writeShellScript "btrbk-archive" ''
      set -e

      cleanup() {
        ${pkgs.util-linux}/bin/umount /run/btrbk/${target}/container || true
        ${pkgs.cryptsetup}/bin/cryptsetup close btrbk-${target} || true
        ${pkgs.util-linux}/bin/umount /run/btrbk/${target}/backups || true
        rmdir /run/btrbk/${target}/{backups,container,} || true
      }
      trap cleanup EXIT

      mkdir -p -m 700 /run/btrbk/${target}/{backups,container}
      ${pkgs.sshfs}/bin/sshfs -C -o IdentityFile=${config.sops.secrets."btrbk/${target}/ssh_key".path} ${targets.${target}} /run/btrbk/${target}/backups
      ${pkgs.cryptsetup}/bin/cryptsetup open --key-file ${config.sops.secrets."btrbk/${target}/encryption_key".path} /run/btrbk/${target}/backups/${host} btrbk-${target}
      ${pkgs.util-linux}/bin/mount /dev/mapper/btrbk-${target} /run/btrbk/${target}/container

      ${cmd}
    '';
  archive = conf: snapshots: target: withTarget target "${pkgs.btrbk}/bin/btrbk -c /etc/btrbk/${conf}.conf archive ${snapshots} /run/btrbk/${target}/container/${conf}";
in {
  services.btrbk = {
    instances.data = {
      onCalendar = "*:0/5";
      settings = {
        archive_preserve_min = "latest";
        archive_preserve = "24h 14d 10w *m";
        volume."/persistent/data" = {
          snapshot_preserve_min = "2h";
          snapshot_preserve = "48h 28d *w";
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };

    instances.cache = {
      onCalendar = "*:0/5";
      settings = {
        volume."/persistent/cache" = {
          snapshot_preserve_min = "1h";
          snapshot_preserve = "4h 3d 2w";
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };
  };

  systemd.services.btrbk-archive = {
    path = [pkgs.sudo];
    script = builtins.concatStringsSep "\n" (map (target: "${pkgs.bash}/bin/bash ${archive "data" "/persistent/data/.snapshots" target}") (builtins.attrNames targets));
  };

  environment.shellAliases = builtins.listToAttrs (map (target: {
    name = "btrbk-target-${target}";
    value = "${pkgs.bash}/bin/bash ${withTarget target "( cd /run/btrbk/${target}/container; $SHELL )"}";
  }) (builtins.attrNames targets));

  sops.secrets = let
    s.sopsFile = ../hosts/${config.networking.hostName}/secrets/default.yml;
  in
    builtins.listToAttrs (lib.flatten (map (target: [
      {
        name = "btrbk/${target}/ssh_key";
        value = s;
      }
      {
        name = "btrbk/${target}/encryption_key";
        value = s;
      }
    ]) (builtins.attrNames targets)));
}
