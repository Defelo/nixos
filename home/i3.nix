{
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  ws0 = "0 ";
  ws1 = "1 ";
  ws2 = "2 ";
  ws3 = "3 ";
  ws4 = "4 ";
  ws5 = "5 ";
  ws6 = "6 ";
  ws7 = "7 ";
  ws8 = "8 ";
  ws9 = "9 ";
  ws10 = "10 ";
  ws42 = "42 ";
  ws1337 = "1337";
  ws_obsidian = "+ ";
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

      "${mod}+asciicircum" = "workspace ${ws0}";
      "${mod}+1" = "workspace ${ws1}";
      "${mod}+2" = "workspace ${ws2}";
      "${mod}+3" = "workspace ${ws3}";
      "${mod}+4" = "workspace ${ws4}";
      "${mod}+5" = "workspace ${ws5}";
      "${mod}+6" = "workspace ${ws6}";
      "${mod}+7" = "workspace ${ws7}";
      "${mod}+8" = "workspace ${ws8}";
      "${mod}+9" = "workspace ${ws9}";
      "${mod}+0" = "workspace ${ws10}";
      "${mod}+ssharp" = "workspace ${ws42}";
      "${mod}+acute" = "workspace ${ws1337}";
      "${mod}+plus" = "workspace ${ws_obsidian}";

      "${mod}+Shift+asciicircum" = "move container to workspace ${ws0}";
      "${mod}+Shift+1" = "move container to workspace ${ws1}";
      "${mod}+Shift+2" = "move container to workspace ${ws2}";
      "${mod}+Shift+3" = "move container to workspace ${ws3}";
      "${mod}+Shift+4" = "move container to workspace ${ws4}";
      "${mod}+Shift+5" = "move container to workspace ${ws5}";
      "${mod}+Shift+6" = "move container to workspace ${ws6}";
      "${mod}+Shift+7" = "move container to workspace ${ws7}";
      "${mod}+Shift+8" = "move container to workspace ${ws8}";
      "${mod}+Shift+9" = "move container to workspace ${ws9}";
      "${mod}+Shift+0" = "move container to workspace ${ws10}";
      "${mod}+Shift+ssharp" = "move container to workspace ${ws42}";
      "${mod}+Shift+acute" = "move container to workspace ${ws1337}";
      "${mod}+Shift+plus" = "move container to workspace ${ws_obsidian}";
    };
    modes = {
      resize = {
        h = "resize shrink width 10 px or 10 ppt";
        j = "resize grow height 10 px or 10 ppt";
        k = "resize shrink height 10 px or 10 ppt";
        l = "resize grow width 10 px or 10 ppt";

        Return = "mode default";
        Escape = "mode default";
      };
    };
    defaultWorkspace = "workspace ${ws2}";
    assigns = {
      ${ws0} = [];
      ${ws1} = [{class = "^Brave-browser$";}];
      ${ws2} = [];
      ${ws3} = [{class = "^jetbrains-.+$";}];
      ${ws4} = [];
      ${ws5} = [];
      ${ws6} = [];
      ${ws7} = [{class = "^thunderbird$";}];
      ${ws8} = [{class = "^discord$";} {class = "^Element$";} {class = "^Slack$";}];
      ${ws9} = [{class = "^TelegramDesktop$";}];
      ${ws10} = [{class = "^vlc$";}];
      ${ws42} = [];
      ${ws1337} = [];
      ${ws_obsidian} = [{class = "^obsidian$";}];
    };
    window = {
      hideEdgeBorders = "both";
      commands = [
        {
          command = "border none";
          criteria.class = ".*";
        }
        {
          command = "floating enable";
          criteria.class = "^Rofi$";
        }
      ];
    };
  };
}
