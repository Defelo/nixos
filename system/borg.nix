{
  conf,
  config,
  lib,
  pkgs,
  ...
}: let
  name = config.networking.hostName;
  repo = "ssh://borg@pve.defelo.de/~/${name}";
  passCommand = "cat ${config.sops.secrets."borg/${name}/encryption_key".path}";
  environment = {
    BORG_RSH = "ssh -i ${config.sops.secrets."borg/${name}/ssh_key".path}";
    BORG_REPO = repo;
    BORG_PASSCOMMAND = passCommand;
    BORG_RELOCATED_REPO_ACCESS_IS_OK = "1";
  };
in {
  services.borgbackup.jobs.data = {
    inherit repo environment;
    paths = ["/home"];
    patterns = [
      "- **/*cache*"
      "- **/*Cache*"
      "- /home/*/.npm"
      "- /home/*/.wine"
      "- /home/*/.konan"
      "- /home/*/.thunderbird"
      "- /home/*/.rustup"
      "- /home/*/.nuget"
      "- /home/*/.cargo"
      "- /home/*/.local/share/JetBrains/Toolbox/apps"
      "- /home/*/.local/share/JetBrains/Toolbox/download"
      "- /home/*/.local/pipx/venvs"
      "- **/node_modules"
      "- **/target"
      "- **/target-tarpaulin"
      "- **/.venv"
    ];
    preHook = lib.mkIf conf.borg.excludeSyncthing ''
      for path in $(${pkgs.yq}/bin/xq -r '.configuration.folder[]|select(.paused=="false")|."@path"' /home/*/.config/syncthing/config.xml); do
        extraCreateArgs="$extraCreateArgs --exclude $path"
      done
    '';
    startAt = [];
    prune.keep = {
      daily = 4;
      weekly = 3;
      monthly = 2;
    };
    encryption.mode = "repokey";
    encryption.passCommand = passCommand;
    compression = "lzma,5";
    extraCreateArgs = "--stats --checkpoint-interval 600";
  };

  environment.shellAliases.setup-borg = builtins.foldl' (acc: var: "${acc} ${var}=${lib.escapeShellArg environment.${var}}") "export" (builtins.attrNames environment);

  sops.secrets = {
    "borg/${name}/ssh_key" = {};
    "borg/${name}/encryption_key" = {};
  };
}
