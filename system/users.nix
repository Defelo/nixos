{conf, ...}: {
  users.users = {
    ${conf.user} = {
      isNormalUser = true;
      uid = conf.uid;
      extraGroups = ["wheel" "docker" "networkmanager" "video" "libvirtd"];
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
  };
}
