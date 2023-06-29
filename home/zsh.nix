{
  config,
  conf,
  pkgs,
  _pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    autocd = true;
    history.share = false;
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

      temp() { (d=$(mktemp -d); cd "$d"; zsh && rm -rf "$d") }
      deltemp() {
        d=$(pwd)
        [[ $(echo $d | cut -d/ -f2) != "tmp" ]] && return
        cd
        rm -rf /tmp/$(echo $d | cut -d/ -f3)
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
        new=$(${pkgs.nix-output-monitor}/bin/nom build --keep-going --print-out-paths --no-link ~/nixos#nixosConfigurations.$(cat /proc/sys/kernel/hostname).config.system.build.toplevel) || return $?
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
        NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$p" -c "$@"
      }

      shot() {
      file=$(mktemp --suffix .png)
      ${_pkgs.termshot}/bin/termshot -f $file $TERMSHOT_FLAGS -- "$@" \
        && ${pkgs.imagemagick}/bin/convert $file -crop 0x0+81+191 -crop -113-140 $file \
        && ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $file \
        && ${pkgs.gnome.eog}/bin/eog $file
      }

      cshot() { TERMSHOT_FLAGS="-c" shot "$@"; }

      jupyter_export(){
        base=$(basename "$1" .ipynb)
        jupyter nbconvert "$1" --to pdf --output "''${base}.pdf"
      }

      backup() {
        (
          export BORG_REPO="$(cat ${config.sops.secrets."borg/${conf.hostname}/borg_repo".path})"
          export BORG_PASSCOMMAND="sudo -u $(whoami) $(cat ${config.sops.secrets."borg/${conf.hostname}/borg_passcommand".path})"
          export HEALTHCHECK="$(cat ${config.sops.secrets."borg/${conf.hostname}/healthcheck".path})"
          export EXCLUDE_SYNCTHING="$(cat ${config.sops.secrets."borg/${conf.hostname}/exclude_syncthing".path})"
          ${../scripts/backup.sh}
        )
      }

      latex() {
        dir=$(mktemp -d)
        pdflatex -output-directory="$dir" "$1" || return $?
        pdflatex -output-directory="$dir" "$1" || return $?
        mv "$dir"/*.pdf .
        rm -rf "$dir"
      }

      latex_preview() {
        dir=$(mktemp -d)
        pdflatex -output-directory="$dir" "$1" || return $?
        (
          ${pkgs.inotify-tools}/bin/inotifywait -m -e modify "$1" | \
            while read; do
              pdflatex -halt-on-error -output-directory="$dir" "$1"
            done
        ) &
        pid=$!
        ${pkgs.okular}/bin/okular "$dir"/*.pdf
        kill $pid
        rm -rf "$dir"
      }

      conf() {
        tmux new -d -s nixos -c ~/nixos hx flake.nix && tmux split -h -t nixos -c ~/nixos -d -l '50%'
        if [[ -n "$TMUX" ]]; then
          tmux switch-client -t nixos
        else
          tmux a -t nixos
        fi
      }

      mitm() {
        ${pkgs.mitmproxy}/bin/mitmweb -q &
        pid=$!
        ${pkgs.proxychains}/bin/proxychains4 -f ${builtins.toFile "proxychains.conf" "quiet_mode\n[ProxyList]\nhttp 127.0.0.1 8080"} zsh
        kill $pid
      }
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
      c = "clear";
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
      qmv = "qmv -f destination-only";
      mnt = "source ${../scripts/mount.sh}";
      tt = "${../scripts/timetracker.sh}";
      beamer = "${../scripts/beamer.sh}";
      drss = "${../scripts/download_rss.sh}";
      sys-rebuild = "_rebuild && source ~/.zshrc";
      sys-rebuild-test = "_rebuild test && source ~/.zshrc";
      sys-rebuild-boot = "_rebuild boot && source ~/.zshrc";
      sys-update = "_update && source ~/.zshrc";
      # conf = "vim ~/nixos/flake.nix";
      repl = "nix repl -f '<nixpkgs>'";
    };
  };
  sops.secrets = {
    "borg/${conf.hostname}/borg_repo" = {};
    "borg/${conf.hostname}/borg_passcommand" = {};
    "borg/${conf.hostname}/healthcheck" = {};
    "borg/${conf.hostname}/exclude_syncthing" = {};
  };
}
