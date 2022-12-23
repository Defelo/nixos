{ lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    python311
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
  ];

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
    plugins = [
      {
        name = "powerlevel10k";
	src = pkgs.zsh-powerlevel10k;
	file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    shellAliases = {
      "ls" = "exa";
      "l" = "ls -al";
      "vim" = "nvim";
      "vi" = "nvim";
      "rebuild" = "sudo nixos-rebuild switch --flake ~/nixos && source ~/.zshrc";
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

  programs.alacritty = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
    publicKeys = [
      { source = ./keys/defelo.pub; trust = 5; }
      { source = ./keys/private.pub; trust = 5; }
    ];
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    initExtra = ''
      xrandr --output Virtual-1 --mode 1920x1080 --rate 60
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
	keybindings = lib.mkOptionDefault {
	  "${modifier}+Return" = "exec alacritty";
	  "${modifier}+Tab" = "workspace back_and_forth";
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
