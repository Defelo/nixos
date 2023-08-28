{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs; [
    # programming
    gcc
    gnumake
    git
    git-crypt
    just

    # browsers
    brave
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })

    # communication
    discord-canary
    (element-desktop.override {
      electron = electron_24;
    })
    tdesktop
    signal-desktop
    pkgs-stable.slack

    # games
    prismlauncher

    # system
    pulsemixer
    pavucontrol
    playerctl
    nix-output-monitor
    wl-clipboard
    xdg-utils
    virt-manager

    # utils
    neofetch
    feh
    gnome.eog
    speedtest-cli
    pwgen
    gh
    imagemagick
    # icat
    termshot
    # exiftool
    # gnome.file-roller
    bc

    obsidian
    vlc
    texlive.combined.scheme-full
    okular
    anki-bin
    spotify
    rnote
  ];
}
