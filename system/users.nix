{
  conf,
  config,
  ...
}: {
  users.mutableUsers = false;
  users.users = {
    ${conf.user} = {
      isNormalUser = true;
      uid = conf.uid;
      extraGroups = ["wheel" "docker" "networkmanager" "video" "libvirtd"];
      passwordFile = config.sops.secrets."user/hashedPassword".path;
    };
  };

  home-manager.users = let
    hm = import ../home;
  in {
    ${conf.user} = {
      imports = hm.user;
      home.username = conf.user;
      home.homeDirectory = conf.home;
    };
    root = {
      imports = hm.root;
      home.username = "root";
      home.homeDirectory = "/root";
    };
  };

  # security.sudo.wheelNeedsPassword = false;
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
    challengeResponsePath = "/persistent/cache/yubico-pam";
  };

  sops.secrets."user/hashedPassword" = {
    sopsFile = ../hosts/${config.networking.hostName}/secrets/default.yml;
    neededForUsers = true;
  };
}
