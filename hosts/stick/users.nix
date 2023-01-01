{...}: let
  user = "user";
in {
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager" "video"];
    };
  };

  home-manager.users = {
    ${user} = {
      imports = [../../home];
    };
  };

  # services.getty.autologinUser = user;

  # security.sudo.wheelNeedsPassword = false;
  security.pam.yubico = {
    enable = true;
    mode = "challenge-response";
  };
}
