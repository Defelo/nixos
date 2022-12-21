{ lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    python311
    exa
    neovim
    meslo-lgs-nf
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
  };

  programs.alacritty = {
    enable = true;
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
	keybindings = lib.mkOptionDefault {
	  "${modifier}+Return" = "exec alacritty";
	};
      };
    };
  };

  home.stateVersion = "22.11";
}
