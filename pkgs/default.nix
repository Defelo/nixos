{pkgs, ...} @ inputs: let
  inp = pkgs // inputs;
in {
  exa = import ./exa.nix inp;
  icat = import ./icat.nix inp;
  termshot = import ./termshot.nix inp;
  sea-orm-cli = import ./sea-orm-cli.nix inp;
}
