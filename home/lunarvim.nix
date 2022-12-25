{ pkgs, ... }:

{
  home.file = {
    lvim = {
      source = builtins.fetchGit {
        url = "https://github.com/lunarvim/lunarvim.git";
        ref = "release-1.2/neovim-0.8";
        rev = "8f4a7bdeb177bed5458ab9cc213519faa8a11859";
      };
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
}
