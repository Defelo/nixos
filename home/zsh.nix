{
  pkgs,
  _pkgs,
  ...
}: {
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

      zstyle ':completion:*' menu select

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

      clip() { xclip -selection clipboard }

      skg() {
          f=$(mktemp -u)
          ssh-keygen -t ed25519 -C "" -P "" -f $f
          cat $f
          cat $f.pub
          rm $f $f.pub
      }

      wgpeer() {
          key=$(wg genkey)
          echo "# Private Key: $key\n[Peer]\nPublicKey = $(wg pubkey <<< $key)\nPresharedKey = $(wg genpsk)\nAllowedIPs = "
      }

      _rebuild() {
        current=$(realpath /run/current-system)
        new=$(nix build --keep-going --print-out-paths --no-link ~/nixos#nixosConfigurations.$(cat /proc/sys/kernel/hostname).config.system.build.toplevel) || return $?
        if [[ "$new" = "$current" ]]; then
          echo "up to date"
          return 1
        fi
        ${pkgs.nvd}/bin/nvd diff $current $new
        sudo nixos-rebuild "''${1:-switch}" --flake ~/nixos
      }

      _update() {
        nix flake update --commit-lock-file ~/nixos && _rebuild
      }

      t() {
        p="$1"
        if [[ "$1" = "sudo" ]]; then p="$2"; fi
        if [[ "$1" = "-p" ]]; then
          p="$2"
          shift 2
        fi
        nix shell "nixpkgs#$p" -c "$@"
      }

      shot() {
      file=$(mktemp --suffix .png)
      ${_pkgs.termshot}/bin/termshot -f $file $TERMSHOT_FLAGS -- "$@" \
        && ${pkgs.imagemagick}/bin/convert $file -crop 0x0+81+191 -crop -113-140 $file \
        && ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $file \
        && ${pkgs.gnome.eog}/bin/eog $file
      }

      cshot() { TERMSHOT_FLAGS="-c" shot "$@"; }

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
      "." = "source";
      ls = "${_pkgs.exa}/bin/exa -g --git --group-directories-first";
      l = "ls -aal";
      tre = "ls -alT";
      vim = "nvim";
      vi = "nvim";
      c = ''printf "\033c"; ${pkgs.neofetch}/bin/neofetch'';
      h = "cd;c";
      grep = "grep --color=auto";
      f = "cd $(pwd -P)";
      curl = "curl -L";
      cif = "curl ifconfig.co";
      ciff = "curl httpbin.org/ip";
      cf = "ping 1.1.1.1";
      bt = "bluetoothctl";
      cal = "cal -m";
      vlc = "vlc -I ncurses";
      py = "python";
      diff = "git diff --no-index";
      sshx = "ssh -o UserKnownHostsFile=/dev/null";
      sftpx = "sftp -o UserKnownHostsFile=/dev/null";
      lsblk = "lsblk -M";
      type = "which";
      j = "just";
      mnt = "source ${../scripts/mount.sh}";
      tt = "${../scripts/timetracker.sh}";
      beamer = "${../scripts/beamer.sh}";
      rebuild = "_rebuild && source ~/.zshrc";
      rebuild-test = "_rebuild test && source ~/.zshrc";
      rebuild-boot = "_rebuild boot && source ~/.zshrc";
      update = "_update && source ~/.zshrc";
      conf = "vim ~/nixos/flake.nix";
      repl = "nix repl -f '<nixpkgs>'";
    };
  };
}
