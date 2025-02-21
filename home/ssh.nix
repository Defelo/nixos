{ config, ... }:
{
  programs.ssh = {
    enable = true;
    serverAliveInterval = 20;
    controlMaster = "auto";
    controlPersist = "2h";
    controlPath = "~/.ssh/master-%C";
    extraConfig = ''
      TCPKeepAlive no
    '';
    includes = [ config.sops.secrets."ssh/hosts".path ];
  };

  sops.secrets = {
    "ssh/hosts" = {
      format = "binary";
      sopsFile = ../secrets/ssh/hosts;
    };
  };
}
