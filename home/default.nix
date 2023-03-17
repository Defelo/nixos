{conf, ...}: {
  imports = [
    ./alacritty.nix
    ./calendar.nix
    ./cheat.nix
    ./direnv.nix
    ./dunst.nix
    ./email.nix
    ./fcitx5.nix
    ./flameshot.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    # ./libreoffice.nix
    # ./lunarvim.nix
    ./nix-index.nix
    ./onboard.nix
    ./packages.nix
    ./pass.nix
    ./picom.nix
    ./playerctld.nix
    ./polybar.nix
    ./programming
    ./redshift.nix
    ./rofi.nix
    ./ssh.nix
    ./syncthing.nix
    ./theme.nix
    ./tmux.nix
    ./vifm.nix
    # ./vscodium.nix
    ./x11.nix
    ./xournalpp.nix
    ./yubikey.nix
    ./zsh.nix
  ];

  home.username = conf.user;
  home.homeDirectory = conf.home;

  home.sessionPath = ["$HOME/.local/bin" "$HOME/.cargo/bin"];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.stateVersion = "22.11";
}
