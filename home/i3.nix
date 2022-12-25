{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
in {
  enable = true;
  package = pkgs.i3-gaps;
  config = {
    modifier = mod;
    keybindings = lib.mkOptionDefault {
      "${mod}+Return" = "exec alacritty";
      "${mod}+d" = ''exec "rofi -combi-modi drun,ssh,run -modi combi -show combi -show-icons"'';

      "${mod}+Tab" = "workspace back_and_forth";

      "${mod}+h" = "focus left";
      "${mod}+j" = "focus down";
      "${mod}+k" = "focus up";
      "${mod}+l" = "focus right";

      "${mod}+Shift+h" = "move left";
      "${mod}+Shift+j" = "move down";
      "${mod}+Shift+k" = "move up";
      "${mod}+Shift+l" = "move right";
    };
  };
}
