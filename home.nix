{ lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    python311
    rustup
    exa
    neovim
    meslo-lgs-nf
    htop
    duf
    ncdu
    brave
    arandr
    git
    git-crypt
    neofetch
    lxappearance
    feh
    gnome.eog
    gnumake
    gcc
  ];

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];

  home.file = {
    lvim = {
      source = ./lunarvim/lunarvim;
      target = ".local/share/lunarvim/lvim";
    };
    lvim_config = {
      source = ./lunarvim/config;
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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    autocd = true;
    initExtra = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

      source ${./p10k.zsh}

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      bindkey '^ ' autosuggest-accept

      ${pkgs.neofetch}/bin/neofetch
    '';
    plugins = [{
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }];
    shellAliases = {
      "ls" = "exa";
      "l" = "ls -al";
      "vim" = "nvim";
      "vi" = "nvim";
      "rebuild" =
        "sudo nixos-rebuild switch --flake ~/nixos\\?submodules=1 && source ~/.zshrc";
      "conf" = "hx ~/nixos";
    };
  };

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "Defelo";
    userEmail = "elodef42@gmail.com";
    difftastic.enable = true;
    signing = {
      key = "E7FE2087E4380E64";
      signByDefault = true;
    };
  };

  programs.alacritty = { enable = true; };

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ./keys/defelo.pub;
        trust = 5;
      }
      {
        source = ./keys/private.pub;
        trust = 5;
      }
    ];
  };

  programs.helix = {
    enable = true;
    languages = [{
      name = "nix";
      auto-format = true;
      language-server = { command = "${pkgs.nil}/bin/nil"; };
      formatter = { command = "${pkgs.nixfmt}/bin/nixfmt"; };
    }];
    settings = {
      theme = "dark_plus";
      editor = {
        line-number = "relative";
        mouse = false;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = { hidden = false; };
        statusline = {
          left = [ "mode" "spinner" ];
          center = [ "file-name" ];
          right = [
            "diagnostics"
            "selections"
            "position"
            "position-percentage"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "|";
        };
        lsp = { display-messages = true; };
        indent-guides = { render = true; };
      };
      keys = {
        normal = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
        };
        select = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
        };
      };
    };
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    initExtra = ''
      xrandr --output Virtual-1 --mode 1920x1080 --rate 60
      ${pkgs.feh}/bin/feh --bg-scale ${./wallpaper.png}
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Tab" = "workspace back_and_forth";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme.name = "Adapta-Nokto";
    theme.package = pkgs.adapta-gtk-theme;
    iconTheme.name = "breeze-dark";
    iconTheme.package = pkgs.breeze-icons;
    font.name = "Cantarell";
    font.size = 12;
    font.package = pkgs.cantarell-fonts;
  };

  home.pointerCursor = {
    package = pkgs.breeze-gtk;
    gtk.enable = true;
    name = "breeze_cursors";
    size = 16;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSshSupport = true;
  };

  home.stateVersion = "22.11";
}
