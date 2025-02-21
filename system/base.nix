{ pkgs, ... }:
{
  users.mutableUsers = false;
  users.users.root.password = "nixos";
  services.getty.autologinUser = "root";

  environment.systemPackages = builtins.attrValues { inherit (pkgs) vim git; };
}
