{ pkgs, pkgs-element, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # programming
      gcc
      gnumake
      git-crypt
      just

      # browsers
      brave
      tor-browser-bundle-bin

      # communication
      discord-canary
      # element-desktop
      signal-desktop

      # games
      prismlauncher
      mindustry-wayland

      # system
      pulsemixer
      pavucontrol
      playerctl
      nix-output-monitor
      wl-clipboard
      xdg-utils
      virt-manager
      wdisplays
      slurp
      grim
      swappy
      wl-mirror

      # utils
      feh
      eog
      speedtest-cli
      pwgen
      xkcdpass
      gh
      imagemagick
      termshot
      bc
      inotify-tools

      obsidian
      vlc

      anki-bin
      spotify
      rnote
      zotero_7
      ;

    inherit (pkgs-element) element-desktop;

    tex = pkgs.texlive.combined.scheme-full;

    networkmanagerapplet = pkgs.networkmanagerapplet.overrideAttrs (attrs: {
      postFixup = ''
        ${attrs.postFixup or ""}
        rm -r $out/etc/xdg/autostart
      '';
    });
  };
}
