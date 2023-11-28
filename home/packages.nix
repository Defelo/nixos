{pkgs, ...}: {
  home.packages = with pkgs; [
    # programming
    gcc
    gnumake
    git
    git-crypt
    just

    # browsers
    brave
    tor-browser-bundle-bin

    # communication
    discord-canary
    (element-desktop.override {
      electron = pkgs.electron_27;
    })

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
    wdisplays
    networkmanagerapplet

    # utils
    neofetch
    feh
    gnome.eog
    speedtest-cli
    pwgen
    xkcdpass
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
