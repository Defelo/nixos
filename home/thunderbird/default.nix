{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [thunderbird gpgme];

  sops.secrets = {
    "thunderbird" = {
      format = "binary";
      sopsFile = ../../secrets/thunderbird;
    };
  };

  systemd.user.services.thunderbird-config = {
    Install.WantedBy = ["default.target"];
    Unit.After = ["sops-nix.service"];
    Service = {
      ExecStart = toString (pkgs.writeShellScript "thunderbird-config.sh" ''
        ${pkgs.coreutils}/bin/mkdir -p ~/.thunderbird/default
        ${pkgs.coreutils}/bin/rm -f ~/.thunderbird/default/user.js
        ${pkgs.python311}/bin/python ${./activate.py} ${config.sops.secrets."thunderbird".path} > ~/.thunderbird/default/user.js
        ${pkgs.coreutils}/bin/chmod 400 ~/.thunderbird/default/user.js
      '');
      Type = "oneshot";
    };
  };

  home.file = {
    ".thunderbird/profiles.ini" = {
      text = ''
        [General]
        StartWithLastProfile=1
        Version=2

        [Profile0]
        Default=1
        IsRelative=1
        Name=default
        Path=default
      '';
    };
  };
}
