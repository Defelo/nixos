{
  system-config,
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
    c = lib.mkForce "clear; is_split || hyfetch";
  };

  impure = system-config.system.replaceDependencies.replacements != [];

  functions = {
    _rebuild = ''
      sudo nixos-rebuild "''${1:-switch}" --flake ~/nixos ${lib.optionalString impure "--impure"} --log-format internal-json -v |& nom --json
    '';
    _update = ''
      nix flake update --commit-lock-file --flake ~/nixos && _rebuild
    '';

    shot = ''
      file=$(mktemp --suffix .png)
      ${pkgs.termshot}/bin/termshot -f $file $TERMSHOT_FLAGS -- "$@" \
        && ${pkgs.imagemagick}/bin/convert $file -crop 0x0+81+191 -crop -113-140 $file \
        && ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png -i $file \
        && ${pkgs.eog}/bin/eog $file
    '';
    cshot = ''TERMSHOT_FLAGS="-c" shot "$@";'';

    is_split = ''
      [[ "$TERM" =~ ^tmux ]] && [[ $(tmux list-panes | wc -l) -gt 1 ]]
    '';

    fwatch = ''
      if [[ $# -eq 0 ]] || [[ "$1" = "--help" ]]; then
        ${lib.getExe' pkgs.inotify-tools "inotifywait"} --help
        return
      fi

      args=()
      while [[ $# -gt 0 ]]; do
        if [[ "$1" = "--" ]]; then shift; break; fi
        args+=("$1")
        shift
      done

      while true; do
        ${lib.getExe' pkgs.inotify-tools "inotifywait"} "''${args[@]}"
        code=$?
        if [[ $code -eq 0 ]]; then
          "$@"
        else
          return $code
        fi
      done
    '';
  };
in {
  imports = [./.];
  programs.zsh = {
    initExtra = let
      ng-completion = pkgs.runCommand "ng-completion" {} ''
        SHELL=zsh ${pkgs.nodePackages."@angular/cli"}/bin/ng completion script > $out
      '';
    in ''
      ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}() {\n${v}\n}") functions)}

      # Load Angular CLI autocompletion.
      source ${ng-completion}

      is_split || hyfetch
    '';
    shellAliases = aliases;
  };
}
