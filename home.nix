{ lib, pkgs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";

  home.packages = with pkgs; [
    python311
    exa
    neovim
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    autocd = true;
    initExtra = ''
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      bindkey '^ ' autosuggest-accept

      ${pkgs.neofetch}/bin/neofetch
    '';
    shellAliases = {
      "ls" = "exa";
      "l" = "ls -al";
      "vim" = "nvim";
      "vi" = "nvim";
      "rebuild" = "sudo nixos-rebuild switch --flake ~/nixos && source ~/.zshrc";
    };
  };

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
