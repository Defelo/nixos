{
  config,
  lib,
  pkgs,
  ...
}: let
  targets = {
    srv = "rest:https://backup.defelo.de";
    home = "rest:https://backup.home.defelo.de";
    box = "sftp://u360850-sub3@u360850.your-storagebox.de:23";
  };

  hostname = config.networking.hostName;

  scriptConfig = let
    script = pkgs.writeShellScriptBin "backup" ''
      if [[ $UID -ne 0 ]]; then
        exec sudo $0 $@
      fi

      systemctl start prepare-backup.service
      journalctl -f${lib.concatMapStrings (target: " -u restic-backups-${target}.service") (builtins.attrNames targets)}
    '';
  in {
    environment.systemPackages = [script];
  };

  prepareConfig = {
    systemd.services.prepare-backup = {
      onSuccess = lib.mapAttrsToList (target: _: "restic-backups-${target}.service") targets;
      restartIfChanged = false;
      path = with pkgs; [coreutils btrfs-progs];
      script = ''
        set -e

        if [[ -e /persistent/data/backup ]]; then
          rm -rf /persistent/data/backup
        fi

        mkdir -m 700 /persistent/data/backup
        cd /persistent/data/backup
        date --iso-8601=seconds > /persistent/data/backup/timestamp

        if [[ -e /persistent/data/.snapshots/backup ]]; then
          btrfs subvolume delete /persistent/data/.snapshots/backup
        fi
        btrfs subvolume snapshot -r /persistent/data /persistent/data/.snapshots/backup
      '';
    };
  };

  groupConfig = {
    users.groups.restic = {};
  };

  backupConfigs =
    lib.mapAttrsToList (target: repo: let
      isRest = lib.hasPrefix "rest:" repo;
      isSftp = lib.hasPrefix "sftp:" repo;
    in {
      services.restic.backups.${target} = {
        timerConfig = null;
        repository = "${repo}/${hostname}";
        environmentFile = lib.mkIf isRest config.sops.templates."backup/${target}".path;
        passwordFile = config.sops.secrets."backup/${target}/repository-password".path;
        extraOptions = lib.optional isSftp "sftp.args='-i ${config.sops.secrets."backup/${target}/ssh-key".path}'";

        initialize = true;
        paths = ["/persistent/data/.snapshots/backup"];
        exclude = [
          "node_modules"
          ".venv"
          "target"
        ];
      };

      sops = {
        secrets = let
          s = {
            sopsFile = ../hosts/${hostname}/secrets/default.yml;
            owner = "root";
            group = "restic";
            mode = "0440";
          };
        in
          {
            "backup/${target}/repository-password" = s;
          }
          // (lib.optionalAttrs isRest {
            "backup/${target}/rest-password" = s;
          })
          // (lib.optionalAttrs isSftp {
            "backup/${target}/ssh-key" = {inherit (s) sopsFile;};
          });
        templates = lib.optionalAttrs isRest {
          "backup/${target}" = {
            content = ''
              RESTIC_REST_USERNAME=${hostname}
              RESTIC_REST_PASSWORD=${config.sops.placeholder."backup/${target}/rest-password"}
            '';
            owner = "root";
            group = "restic";
            mode = "0440";
          };
        };
      };
    })
    targets;
in
  lib.mkMerge ([scriptConfig prepareConfig groupConfig] ++ backupConfigs)
