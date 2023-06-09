{config, ...}: {
  programs.ssh = {
    enable = true;
    serverAliveInterval = 20;
    extraConfig = ''
      TCPKeepAlive no
    '';
    includes = [config.sops.secrets."ssh/hosts".path];
  };

  sops.secrets = {
    "ssh/hosts" = {
      format = "binary";
      sopsFile = ../secrets/ssh/hosts;
    };
  };
}
