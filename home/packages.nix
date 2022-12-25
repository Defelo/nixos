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

    # fonts
    meslo-lgs-nf

    # system
    arandr

    # utils
    htop
    duf
    ncdu
    neofetch
    feh
    gnome.eog
  ];
}
