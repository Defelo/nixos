{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # rnix-lsp
      alejandra
      nixfmt-rfc-style
      ;
  };
}
