{
  conf,
  config,
  pkgs,
  ...
}: {
  systemd.user.services.ntfy-sub = {
    Install.WantedBy = ["default.target"];
    Unit.After = ["sops-nix.service" "dunst.service"];
    Service = {
      ExecStart = "${pkgs.bash}/bin/bash ${../scripts/ntfy-sub.sh} ${config.sops.secrets.ntfy.path}";
      Environment = "PATH=${pkgs.lib.makeBinPath (with pkgs; [coreutils jq dunst xdg-utils ntfy-sh])}";
    };
  };

  home.packages = [pkgs.ntfy-sh];
  programs.zsh.shellAliases.ny = "ntfy pub defelo";

  sops.secrets.ntfy = {
    sopsFile = ../secrets/ntfy;
    format = "binary";
    path = "${conf.home}/.config/ntfy/client.yml";
  };
}
