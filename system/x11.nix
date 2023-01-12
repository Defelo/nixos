{
  conf,
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;

    displayManager.startx.enable = true;

    layout = "de";
    xkbVariant = "nodeadkeys";

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        horizontalScrolling = false;
      };
    };

    videoDrivers = ["intel" "amdgpu" "radeon" "nouveau" "modesetting" "fbdev"];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        shell = config.users.defaultUserShell;
      in "${pkgs.greetd.greetd}/bin/agreety --cmd ${shell}${shell.shellPath}";
      initial_session = {
        user = conf.user;
        command = "startx";
      };
    };
  };
}
