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
in {
  user =
    common
    ++ [
      ./alacritty.nix
      ./clipman.nix
      ./dunst.nix
      ./fcitx5.nix
      ./gammastep.nix
      ./git.nix
      ./gpg.nix
      ./helix/full.nix
      ./libreoffice.nix
      ./ntfy.nix
      ./packages.nix
      ./pass.nix
      ./playerctld.nix
      ./programming
      ./rofi
      ./sops.nix
      ./ssh.nix
      ./sway.nix
      ./syncthing.nix
      ./theme.nix
      ./thunderbird
      ./vscodium.nix
      ./waybar.nix
      ./xournalpp
      ./yubikey.nix
      ./zsh/full.nix
    ];

  root = common;
}
