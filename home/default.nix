let
  common = [
    ./common.nix

    ./cheat.nix
    ./direnv.nix
    ./fzf.nix
    ./helix
    ./nix-index.nix
    ./tmux.nix
    ./zoxide.nix
    ./zsh
  ];
in
{
  user = common ++ [
    ./aerc.nix
    ./alacritty.nix
    ./clipman.nix
    ./dunst.nix
    # ./fcitx5.nix
    ./gammastep.nix
    ./git.nix
    ./gpg.nix
    ./helix/full.nix
    ./hyfetch.nix
    # ./libreoffice.nix
    ./niri
    ./ntfy.nix
    ./packages.nix
    ./pass.nix
    ./playerctld.nix
    ./programming
    ./rofi
    ./sops.nix
    ./ssh.nix
    ./syncthing.nix
    ./theme.nix
    ./vscodium.nix
    ./waybar.nix
    ./xournalpp
    ./yubikey.nix
    ./zsh/full.nix
  ];

  root = common;
}
