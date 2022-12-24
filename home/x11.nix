{ pkgs, lib, ... }:

{
  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    initExtra = ''
      xrandr --output Virtual-1 --mode 1920x1080 --rate 60
      ${pkgs.feh}/bin/feh --bg-scale ${../wallpaper.png}
    '';
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
        keybindings = lib.mkOptionDefault {
          "${modifier}+Return" = "exec alacritty";
          "${modifier}+Tab" = "workspace back_and_forth";
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
        };
      };
    };
  };
}
