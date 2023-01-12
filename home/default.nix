{
  conf,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./calendar.nix
    ./cheat.nix
    ./direnv.nix
    ./dunst.nix
    ./email.nix
    ./fcitx5.nix
    ./flameshot.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    ./lunarvim.nix
    ./onboard.nix
    ./packages.nix
    ./pass.nix
    ./picom.nix
    ./polybar.nix
    ./redshift.nix
    ./rofi.nix
    ./rust.nix
    ./ssh.nix
    ./syncthing.nix
    ./theme.nix
    ./vifm.nix
    ./vscodium.nix
    ./x11.nix
    ./xournalpp.nix
    ./zsh.nix
  ];

  home.username = conf.user;
  home.homeDirectory = conf.home;

  home.sessionPath = ["$HOME/.local/bin" "$HOME/.cargo/bin"];

  home.stateVersion = "22.11";
}
