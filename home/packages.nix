{
  lib,
  pkgs,
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
    rustup
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
    unp
    pwgen
    dig
    gh

    obsidian
    vlc
    texlive.combined.scheme-full
    okular
  ];
}
