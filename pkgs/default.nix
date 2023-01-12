{pkgs, ...}: {
  exa = import ./exa.nix pkgs;
  icat = import ./icat.nix pkgs;
}
