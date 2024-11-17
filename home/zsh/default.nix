{
  pkgs,
  lib,
  ...
}: let
  aliases = {
    "." = "source";
    ls = "EXA_COLORS='xx=2;37' ${pkgs.eza}/bin/eza -g --git --group-directories-first";
    l = "ls -aal";
    tre = "ls -alT";
    c = "clear";
    h = "cd;c";
    grep = "grep --color=auto";
    f = "cd $(pwd -P)";
    curl = "curl -L";
    cif = "curl ifconfig.co";
    ciff = "curl httpbin.org/ip";
    cf = "ping 1.1.1.1";
    cal = "cal -m";
    py = "python";
    diff = "git diff --no-index";
    sshx = "ssh -o UserKnownHostsFile=/dev/null";
    sftpx = "sftp -o UserKnownHostsFile=/dev/null";
    lsblk = "lsblk -M";
    type = "which";
    j = "just";
    qmv = "qmv -f destination-only";
    repl = "nix repl -f '<nixpkgs>'";
    da = "direnv allow";
    de = "direnv edit .";
    dr = "direnv reload";
    db = "direnv block";
    duff = "duf /persistent/* /nix /";
    mksv = "btrfs subvolume create";
  };
  functions = {
    d = "dirs -v | tac";
    mkcd = ''mkdir -p "$1"; cd "$1"'';
    temp = ''(d=$(mktemp -d); cd "$d"; zsh && rm -rf "$d")'';

    skg = ''
      f=$(mktemp -u)
      ssh-keygen -t ed25519 -C "" -P "" -f $f
      cat $f
      cat $f.pub
      rm $f $f.pub
    '';
    wgpeer = ''
      key=$(wg genkey)
      echo "# Private Key: $key\n[Peer]\nPublicKey = $(wg pubkey <<< $key)\nPresharedKey = $(wg genpsk)\nAllowedIPs = "
    '';

    s = ''
      tmux new -d -c ~ -s "$1"
      if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$1"
      else
        tmux a -t "$1"
      fi
    '';

    is_btrfs_subvolume = ''
      local dir=''${1:-.}
      [[ "$(stat -f --format=%T $dir)" = "btrfs" ]] && [[ "$(stat --format=%i $dir)" =~ ^(2|256)$ ]]
    '';
  };
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    autocd = true;
    history.share = false;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initExtra = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

      source ${./p10k.zsh}

      ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      bindkey '^ ' autosuggest-accept

      zstyle ':completion:*' menu select

      setopt autopushd

      # custom functions
      ${(builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}() {\n${v}\n}") functions))}
    '';
    shellAliases = aliases;
  };
}
