{
  pkgs,
  lib,
  ...
}: let
  aliases = {
    bt = "bluetoothctl";
    vlc = "vlc -I ncurses";
    mnt = "source ${../scripts/mount.sh}";
    tt = "${../scripts/timetracker.sh}";
    drss = "${../scripts/download_rss.sh}";
    sys-rebuild = "_rebuild && source /etc/zshrc && source ~/.zshrc";
    sys-update = "_update && source /etc/zshrc && source ~/.zshrc";
    backup = "sudo systemctl start btrbk-archive && sudo journalctl -fu btrbk-archive";
  };
  functions = {
    _rebuild = ''
      sudo nixos-rebuild "''${1:-switch}" --flake ~/nixos --log-format internal-json -v |& nom --json
    '';
    _update = ''
      nix flake update --commit-lock-file ~/nixos && _rebuild
    '';
    conf = ''
      tmux new -d -s nixos -c ~/nixos hx flake.nix && tmux split -h -t nixos -c ~/nixos -d -l '50%'
      if [[ -n "$TMUX" ]]; then
        tmux switch-client -t nixos
      else
        tmux a -t nixos
      fi
    '';

    shot = ''
      file=$(mktemp --suffix .png)
      ${pkgs.termshot}/bin/termshot -f $file $TERMSHOT_FLAGS -- "$@" \
        && ${pkgs.imagemagick}/bin/convert $file -crop 0x0+81+191 -crop -113-140 $file \
        && ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $file \
        && ${pkgs.gnome.eog}/bin/eog $file
    '';
    cshot = ''TERMSHOT_FLAGS="-c" shot "$@";'';

    jupyter_export = ''
      base=$(basename "$1" .ipynb)
      jupyter nbconvert "$1" --to pdf --output "''${base}.pdf"
    '';

    latex = ''
      dir=$(mktemp -d)
      pdflatex -output-directory="$dir" "$1" || return $?
      pdflatex -output-directory="$dir" "$1" || return $?
      mv "$dir"/*.pdf .
      rm -rf "$dir"
    '';
    latex_preview = ''
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
    '';

    mitm = ''
      ${pkgs.mitmproxy}/bin/mitmweb -q &
      pid=$!
      ${pkgs.proxychains}/bin/proxychains4 -f ${builtins.toFile "proxychains.conf" "quiet_mode\n[ProxyList]\nhttp 127.0.0.1 8080"} zsh
      kill $pid
    '';
  };
in {
  imports = [./.];
  programs.zsh = {
    initExtra = ''
      ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}() {\n${v}\n}") functions)}

      # Load Angular CLI autocompletion.
      source <(ng completion script)
    '';
    shellAliases = aliases;
  };
}
