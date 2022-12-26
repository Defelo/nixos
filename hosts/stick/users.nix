{...}: let
  user = "user";
in {
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker" "networkmanager"];
    };
  };

  home-manager.users = {
    ${user} = {
      imports = [../../home];
    };
  };

  # services.getty.autologinUser = user;

  security.sudo.wheelNeedsPassword = false;
}
