{conf, ...}: {
  users.users = {
    ${conf.user} = {
      isNormalUser = true;
      uid = conf.uid;
      extraGroups = ["wheel" "docker" "networkmanager" "video" "libvirtd"];
    };
  };

  home-manager.users = {
    ${conf.user} = {
      imports = [../home];
    };
  };

  # services.getty.autologinUser = user;

  # security.sudo.wheelNeedsPassword = false;
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
