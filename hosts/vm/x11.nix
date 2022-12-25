{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.xserver.desktopManager = {
    xterm.enable = false;
    session = [{
      name = "home-manager";
      start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
      '';
    }];
  };
  services.xserver.displayManager = {
    lightdm.enable = true;
    defaultSession = "home-manager";
    autoLogin = {
      enable = true;
      user = "user";
    };
  };

  services.xserver.layout = "de";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # services.xserver.libinput.enable = true;
}
