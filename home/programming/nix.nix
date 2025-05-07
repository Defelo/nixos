{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # rnix-lsp
      nixfmt-rfc-style
      ;
  };
}
