{ lib, pkgs, ... }:

{
  tree-root-file = ".git/config";
  on-unmatched = "error";

  excludes = [
    # no formatter available
    ".gitattributes"
    "LICENSE"
    "*.kdl"
    "*.md"
    "*.rasi"

    # generated/managed by other programs
    "home/xournalpp/settings/*"
    "home/zsh/p10k.zsh"
    "hosts/*/hardware-configuration.nix"
    "secrets/*"
    "*/secrets/*"
    "*.lock"

    # not text
    "*.jpg"
    "*.png"
  ];

  formatter.black = {
    command = lib.getExe pkgs.black;
    includes = [ "*.py" ];
    options = [ ];
  };

  formatter.nixfmt = {
    command = lib.getExe pkgs.nixfmt-rfc-style;
    includes = [ "*.nix" ];
    options = [ "--strict" ];
  };

  formatter.prettier = {
    command = lib.getExe pkgs.nodePackages.prettier;
    includes = [
      "*.json"
      "*.yml"
      "*.yaml"
    ];
    options = [ "--write" ];
  };

  formatter.shfmt = {
    command = lib.getExe pkgs.shfmt;
    includes = [ "*.sh" ];
    options = [
      "--simplify"
      "--write"
      "--indent=2"
    ];
  };
}
