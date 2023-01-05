{conf, ...}: {
  users.users = {
    ${conf.user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager" "video"];
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
