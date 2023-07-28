let
  common = [
    ./common.nix

    ./cheat.nix
    ./direnv.nix
    ./fzf.nix
    ./helix
    ./nix-index.nix
    ./tmux.nix
    ./zsh.nix
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
      # ./libreoffice.nix
      ./ntfy.nix
      ./packages.nix
      ./pass.nix
      ./playerctld.nix
      ./programming
      ./rofi.nix
      ./sops.nix
      ./ssh.nix
      ./sway.nix
      ./syncthing.nix
      ./theme.nix
      ./thunderbird
      ./vscodium.nix
      ./waybar.nix
      ./xournalpp.nix
      ./yubikey.nix
    ];

  root = common;
}
