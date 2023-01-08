{
  pkgs,
  lunarvim,
  ...
}: {
  home.packages = with pkgs; [
    ripgrep
    gnumake
    gcc
    xclip

    # language servers
    pyright # python
    rust-analyzer # rust
    rnix-lsp # nix

    # formatters
    alejandra # nix
  ];

  home.file = {
    lvim = {
      source = lunarvim;
      target = ".local/share/lunarvim/lvim";
    };
    lvim_config = {
      source = ../lunarvim/config;
      target = ".config/lvim";
      recursive = true;
    };
    lvim_bin = {
      text = ''
        #!/usr/bin/env bash

        export LUNARVIM_RUNTIME_DIR=~/.local/share/lunarvim
        export LUNARVIM_CONFIG_DIR=~/.config/lvim
        export LUNARVIM_CACHE_DIR=~/.cache/lvim

        export LUNARVIM_BASE_DIR=~/.local/share/lunarvim/lvim

        exec -a lvim ${pkgs.neovim}/bin/nvim -u "$LUNARVIM_BASE_DIR/init.lua" "$@"
      '';
      target = ".local/bin/lvim";
      executable = true;
    };
  };

  home.shellAliases = {
    "nvim" = "~/.local/bin/lvim";
  };
  home.sessionVariables = {
    EDITOR = "lvim";
    VISUAL = "lvim";
  };
}
