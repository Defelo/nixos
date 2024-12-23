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
    element-desktop
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
    networkmanagerapplet

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
    texlive.combined.scheme-full
    okular
    anki-bin
    spotify
    rnote
    zotero_7
  ];
}
