{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # programming
    python311
    rustup
    git
    git-crypt
    gnumake
    gcc

    # editors
    neovim

    # browsers
    brave

    # fonts
    meslo-lgs-nf

    # system
    arandr
    lxappearance

    # utils
    exa
    htop
    duf
    ncdu
    neofetch
    feh
    gnome.eog
  ];
}
