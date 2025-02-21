{
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
