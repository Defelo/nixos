{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;

    displayManager.startx.enable = true;

    layout = "de";

    # libinput.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        shell = config.users.defaultUserShell;
      in "${pkgs.greetd.greetd}/bin/agreety --cmd ${shell}${shell.shellPath}";
      initial_session = {
        user = "user";
        command = "startx";
      };
    };
  };

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
}
