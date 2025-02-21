{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    python = pkgs.python311.withPackages (p: builtins.attrValues { inherit (p) numpy requests; });

    inherit (pkgs)
      poetry
      poethepoet
      pyright
      ruff
      ;
  };
}
