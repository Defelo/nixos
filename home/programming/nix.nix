{pkgs, ...}: {
  home.packages = with pkgs; [
    # rnix-lsp
    alejandra
    nixfmt-rfc-style
  ];
}
