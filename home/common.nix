{
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    PAGER = "less -FRX";
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
