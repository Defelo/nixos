{pkgs, ...}: {
  users.mutableUsers = false;
  users.users.root.password = "nixos";

  environment.systemPackages = with pkgs; [
    vim
    git
  ];
}
