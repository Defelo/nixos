{
  lib,
  pkgs,
  _pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # programming
    (python310.withPackages (pkgs:
      with pkgs; [
        numpy
        pandas
        matplotlib
        scipy
        jupyterlab
      ]))
    gcc
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
    arandr
    wireguard-tools
    pulsemixer
    pavucontrol
    playerctl
    wirelesstools
    iw

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
    _pkgs.icat
    _pkgs.termshot
    exiftool
    xxd
    gnome.file-roller

    obsidian
    vlc
    texlive.combined.scheme-full
    okular
  ];
}
