{
  conf,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./packages.nix
    ./lunarvim.nix
    ./zsh.nix
    ./git.nix
    ./alacritty.nix
    ./gpg.nix
    ./helix.nix
    ./theme.nix
    ./x11.nix
    ./rofi.nix
    ./picom.nix
    ./syncthing.nix
    ./flameshot.nix
    ./dunst.nix
    ./polybar.nix
    ./cheat.nix
    ./email.nix
    ./pass.nix
  ];

  home.username = conf.user;
  home.homeDirectory = conf.home;

  home.sessionPath = ["$HOME/.local/bin" "$HOME/.cargo/bin"];

  home.stateVersion = "22.11";
}
