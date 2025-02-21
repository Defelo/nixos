{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./uiua.nix
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs) nodejs lean4;
    inherit (pkgs.nodePackages) "@angular/cli" live-server;
  };
}
