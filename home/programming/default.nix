{pkgs, ...}: {
  imports = [
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./uiua.nix
  ];

  home.packages = with pkgs; [
    nodejs
    nodePackages."@angular/cli"
    nodePackages.live-server

    lean4
  ];
}
