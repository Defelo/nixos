{ pkgs, ... }:

{
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

      source ${../p10k.zsh}

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      bindkey '^ ' autosuggest-accept

      bindkey "^R" history-incremental-search-backward
      bindkey "^S" history-incremental-search-forward

      setopt autopushd

      d() { dirs -v | tac }

      mkcd() { mkdir -p "$1"; cd "$1" }

      temp() { cd $(mktemp -d) }
      deltemp() {
        d=$(pwd)
        [[ $(echo $d | cut -d/ -f2) != "tmp" ]] && return
        cd
        rm -r /tmp/$(echo $d | cut -d/ -f3)
      }

      ${pkgs.neofetch}/bin/neofetch
    '';
    plugins = [{
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }];
    shellAliases = {
      "ls" = "${pkgs.exa}/bin/exa";
      "l" = "ls -al";
      "vim" = "nvim";
      "vi" = "nvim";
      "rebuild" = "sudo nixos-rebuild switch --flake ~/nixos && source ~/.zshrc";
      "update" = "nix flake update --commit-lock-file ~/nixos && rebuild";
      "conf" = "vim ~/nixos/flake.nix";
    };
  };
}
