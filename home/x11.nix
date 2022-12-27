{
  pkgs,
  lib,
  ...
} @ inputs: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      xrandr --output Virtual-1 --mode 1920x1080 --rate 60
      ${pkgs.feh}/bin/feh --bg-scale ${../wallpaper.png}
      alacritty &
    '';
    windowManager.i3 = import ./i3.nix inputs;
  };
}
