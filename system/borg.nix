{
  config,
  lib,
  ...
}: let
  name = config.networking.hostName;
  repo = "ssh://borg@pve.defelo.de:2022/~/${name}";
  passCommand = "cat ${config.sops.secrets."borg/encryption_key".path}";
  environment = {
    BORG_RSH = "ssh -i ${config.sops.secrets."borg/ssh_key".path}";
    BORG_REPO = repo;
    BORG_PASSCOMMAND = passCommand;
    BORG_RELOCATED_REPO_ACCESS_IS_OK = "1";
  };
in {
  services.borgbackup.jobs.data = {
    inherit repo environment;
    paths = ["/persistent/data"];
    patterns = [
      "- **/node_modules"
      "- **/.venv"
    ];
    # TODO
    # preHook = lib.mkIf conf.borg.excludeSyncthing ''
    #   for path in $(${pkgs.yq}/bin/xq -r '.configuration.folder[]|select(.paused=="false")|."@path"' /home/*/.config/syncthing/config.xml); do
    #     extraCreateArgs="$extraCreateArgs --exclude $path"
    #   done
    # '';
    startAt = [];
    prune.keep = {
      daily = 4;
      weekly = 3;
      monthly = 2;
    };
    encryption.mode = "repokey";
    encryption.passCommand = passCommand;
    compression = "lzma,5";
    extraCreateArgs = "--stats --checkpoint-interval 600 --one-file-system";
  };

  environment.shellAliases.setup-borg = builtins.foldl' (acc: var: "${acc} ${var}=${lib.escapeShellArg environment.${var}}") "export" (builtins.attrNames environment);

  sops.secrets = let
    s.sopsFile = ../hosts/${name}/secrets/default.yml;
  in {
    "borg/ssh_key" = s;
    "borg/encryption_key" = s;
  };
}
