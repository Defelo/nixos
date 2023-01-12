{pkgs, ...} @ inputs: let
  inp = pkgs // inputs;
in {
  exa = import ./exa.nix inp;
  icat = import ./icat.nix inp;
}
