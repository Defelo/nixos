{pkgs, ...}: {
  users.mutableUsers = false;
  users.users.root.password = "nixos";
  services.getty.autologinUser = "root";

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
