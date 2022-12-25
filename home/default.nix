{ lib, pkgs, ... }:

{
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
  ];

  home.username = "user";
  home.homeDirectory = "/home/user";

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/.cargo/bin" ];

  home.stateVersion = "22.11";
}
