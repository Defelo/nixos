{
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # programming
    gcc
    gnumake
    git
    git-crypt
    just

    # editors
    neovim

    # browsers
    brave

    # communication
    discord-canary
    element-desktop
    tdesktop
    signal-desktop
    slack

    # system
    wireguard-tools
    pulsemixer
    pavucontrol
    playerctl
    wirelesstools
    iw
    nix-output-monitor
    wl-clipboard
    xdg-utils

    # utils
    htop
    duf
    ncdu
    neofetch
    feh
    gnome.eog
    speedtest-cli
    jq
    yq
    file
    zip
    unp
    pwgen
    dig
    gh
    imagemagick
    # _pkgs.icat
    _pkgs.termshot
    # exiftool
    xxd
    # gnome.file-roller
    borgbackup
    ripgrep
    sd
    age
    sops
    renameutils
    bc
    comma
    nvd
    nix-tree

    obsidian
    vlc
    texlive.combined.scheme-full
    okular
    anki-bin
    spotify
  ];
}
