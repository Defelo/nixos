{pkgs, ...}: {
  home.packages = with pkgs; [
    # rnix-lsp
    alejandra
  ];
}
