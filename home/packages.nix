{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # programming
    python311
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
    thunderbird
    tdesktop
    signal-desktop
    slack

    # fonts
    meslo-lgs-nf

    # system
    arandr
    pulsemixer
    pavucontrol
    playerctl

    # utils
    htop
    duf
    ncdu
    neofetch
    feh
    gnome.eog

    xournalpp
    obsidian
  ];
}
