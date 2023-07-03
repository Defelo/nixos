{conf, ...}: {
  imports = [
    ./alacritty.nix
    ./cheat.nix
    ./clipman.nix
    ./direnv.nix
    ./dunst.nix
    # ./emacs.nix
    ./fcitx5.nix
    ./fzf.nix
    ./gammastep.nix
    ./git.nix
    ./gpg.nix
    ./helix.nix
    # ./libreoffice.nix
    # ./lunarvim.nix
    ./nix-index.nix
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
    ./tmux.nix
    ./vifm.nix
    ./vscodium.nix
    ./waybar.nix
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

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
