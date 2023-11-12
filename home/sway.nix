{
  pkgs,
  conf,
  lib,
  config,
  ...
}: let
  mod = "Mod4";
  ws0 = "0";
  ws1 = "1";
  ws2 = "2";
  ws3 = "3";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9";
  ws10 = "10";
  ws42 = "42";
  ws1337 = "1337";
  ws_obsidian = "+";

  lock-command = builtins.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--screenshots"
    "--clock"
    "--submit-on-touch"
    "--show-failed-attempts"
    "--effect-pixelate 8"
    "--fade-in 0.5"
  ];
in {
  wayland.windowManager.sway = {
    enable = true;

    systemd.enable = true;
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      # SDL:
      export SDL_VIDEODRIVER=wayland
      # QT (needs qt5.qtwayland in systemPackages):
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      # Fix for some Java AWT applications (e.g. Android Studio),
      # use this if they aren't displayed properly:
      export _JAVA_AWT_WM_NONREPARENTING=1
      # firefox/tor-browser
      export MOZ_ENABLE_WAYLAND=1

      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_DESKTOP=sway

      export NIXOS_OZONE_WL=1
    '';

    config = {
      input =
        {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_variant = "nodeadkeys";
            xkb_options = "ctrl:swapcaps";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "enabled";
          };
        }
        // (
          let
            outputs = builtins.filter (k: conf.wayland.outputs.${k}.touch) (builtins.attrNames conf.wayland.outputs);
          in
            lib.optionalAttrs (outputs != []) (let
              output = conf.wayland.outputs.${builtins.head outputs}.name;
            in {
              "type:tablet_tool".map_to_output = output;
              "type:touch".map_to_output = output;
            })
        );
      output =
        {
          "*" = {
            bg = "${../wallpapers/nix-snowflake-dark.png} fill";
          };
        }
        // (builtins.listToAttrs (map (k: let
          v = conf.wayland.outputs.${k};
        in {
          name = v.name;
          value = {inherit (v) pos mode scale;};
        }) (builtins.filter (k: conf.wayland.outputs.${k}.name != null) (builtins.attrNames conf.wayland.outputs))));
      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
        };
      };

      startup = [
        {
          command = "systemctl --user restart waybar";
          always = true;
        }
        {command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${lock-command}";}
        {command = "brave";}
        {command = "thunderbird";}
        {command = "discordcanary";}
        {command = "element-desktop";}
        {command = "obsidian";}
        {command = "alacritty -e tmux";}
      ];

      modifier = mod;
      keybindings = let
        alacritty = "alacritty $(swaymsg -t get_tree -r | jq '.nodes[].nodes[]|select(.focused)' | grep -q . || echo --class=floating_term)";
      in
        lib.mkOptionDefault {
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";

          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";

          "${mod}+a" = "focus parent";
          "${mod}+c" = "focus child";

          "${mod}+n" = "split h";
          "${mod}+v" = "split v";

          "${mod}+Tab" = "workspace back_and_forth";

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

          "${mod}+Ctrl+j" = "move workspace output left";
          "${mod}+Ctrl+k" = "move workspace output right";

          "${mod}+Return" = "exec ${alacritty}";
          "${mod}+d" = ''exec "rofi -combi-modi drun,ssh,run -modi combi -show combi -show-icons"'';

          "${mod}+Shift+y" = "exec ${lock-command}";

          "${mod}+Ctrl+M" = let
            cmd = pkgs.writeShellScript "rofipass-wrapped.sh" ''
              export PASSWORD_STORE_DIR=${pkgs.lib.escapeShellArg config.programs.password-store.settings.PASSWORD_STORE_DIR}
              export PATH=${pkgs.lib.escapeShellArg (pkgs.lib.makeBinPath (with pkgs; [pass wl-clipboard rofi-wayland dunst clipman]))}:$PATH
              exec -a rofipass.sh ${./scripts/rofipass.sh} "$@"
            '';
          in "exec ${cmd}";
          "${mod}+P" = "exec ${alacritty} -e python";
          "${mod}+Shift+P" = "exec ${alacritty} -e pulsemixer";

          # "${mod}+odiaeresis" = "exec systemctl --user status picom && systemctl --user stop picom || systemctl --user start picom";

          "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_SINK@ 0.05+";
          "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_SINK@ 0.05-";
          "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";
          "Shift+XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_SOURCE@ 0.05+";
          "Shift+XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume -l 1.0 @DEFAULT_SOURCE@ 0.05-";
          "Shift+XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_SOURCE@ toggle";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "Next" = "exec playerctl play-pause";
          "XF86AudioStop" = "exec playerctl stop";
          "Prior" = "exec playerctl stop";
          "XF86AudioNext" = "exec playerctl next";
          "End" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "Home" = "exec playerctl previous";

          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";
          "Shift+XF86MonBrightnessUp" = "exec light -A 1";
          "Shift+XF86MonBrightnessDown" = "exec light -U 1";

          "${mod}+numbersign" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o - | ${pkgs.wl-clipboard}/bin/wl-copy -t image/png'';

          "${mod}+KP_Add" = "exec dunstctl set-paused toggle";
          "${mod}+comma" = "exec dunstctl close";
          "${mod}+Shift+comma" = "exec dunstctl close-all";
          "${mod}+Shift+period" = "exec dunstctl history-pop";
          "${mod}+period" = "exec dunstctl context";

          "${mod}+m" = "exec ${pkgs.clipman}/bin/clipman pick -t rofi";
          "${mod}+Shift+m" = "exec ${pkgs.clipman}/bin/clipman clear -t rofi";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";
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
        ${ws1} = [{app_id = "^brave-browser$";}];
        ${ws2} = [];
        ${ws3} = [];
        ${ws4} = [];
        ${ws5} = [];
        ${ws6} = [];
        ${ws7} = [{app_id = "^thunderbird$";}];
        ${ws8} = [{app_id = "^discord$";}];
        ${ws9} = [{app_id = "^Element$";}];
        ${ws10} = [];
        ${ws42} = [];
        ${ws1337} = [];
        ${ws_obsidian} = [{app_id = "^obsidian$";}];
      };
      bars = [];
      colors = let
        bg-color = "#222d32";
        inactive-bg-color = "#2f343f";
        text-color = "#f3f4f5";
        inactive-text-color = "#676E7D";
        urgent-bg-color = "#E53935";
      in {
        focused = {
          border = bg-color;
          childBorder = bg-color;
          background = bg-color;
          text = text-color;
          indicator = bg-color;
        };
        unfocused = {
          border = inactive-bg-color;
          childBorder = inactive-bg-color;
          background = inactive-bg-color;
          text = inactive-text-color;
          indicator = bg-color;
        };
        focusedInactive = {
          border = inactive-bg-color;
          childBorder = inactive-bg-color;
          background = inactive-bg-color;
          text = inactive-text-color;
          indicator = bg-color;
        };
        urgent = {
          border = urgent-bg-color;
          childBorder = urgent-bg-color;
          background = urgent-bg-color;
          text = text-color;
          indicator = bg-color;
        };
      };
      floating = {
        titlebar = false;
        criteria = [
          {class = "^Rofi$";}
        ];
      };
      focus = {
        followMouse = true;
        mouseWarping = true;
      };
      fonts = {
        names = ["monospace"];
        size = 10.0;
      };
      window = {
        hideEdgeBorders = "both";
        commands = [
          {
            command = "border none";
            criteria.app_id = ".*";
          }
          {
            command = "floating true";
            criteria.app_id = "floating_term";
          }
          # {
          #   command = "opacity 0.9";
          #   criteria.app_id = ".*";
          # }
        ];
      };
      workspaceOutputAssign = let
        workspaces = [ws2 ws0 ws1 ws3 ws4 ws5 ws6 ws7 ws8 ws9 ws10 ws42 ws1337 ws_obsidian];
        outputs = builtins.filter (v: v.name != null) (builtins.attrValues conf.wayland.outputs);
        assigned = lib.flatten (map (v: v.workspaces) (builtins.filter (v: v.workspaces != null) outputs));
        unassigned = lib.subtractLists assigned workspaces;
      in
        lib.flatten (
          map (v: let
            ws =
              if v.workspaces == null
              then unassigned
              else v.workspaces;
          in
            map (w: {
              workspace = w;
              output = v.name;
            })
            ws)
          outputs
        );
    };
  };
}
