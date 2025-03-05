{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    python = pkgs.python313.withPackages (p: builtins.attrValues { inherit (p) numpy requests; });

    inherit (pkgs)
      poetry
      poethepoet
      pyright
      ruff
      ;
  };
}
