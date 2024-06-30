{
  conf,
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = let
      mkDisk = name: path: {
        inherit path;
        interval = 5;
        format = "${name} {percentage_used}%";
        states = {
          critical = 90;
          warning = 80;
        };
      };
      base = {
        layer = "top";
        position = "top";
        height = 20;
        fixed-center = false;

        "custom/yk" = let
          script = builtins.toFile "yktd.py" ''
            import json, socket, os
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(f"/run/user/{os.getuid()}/yubikey-touch-detector.socket")
            def update(touch):
              print(json.dumps({
                "text": "",
                "tooltip": "YubiKey is waiting for a touch",
              } if touch else {}), flush=True)
            update(False)
            while True: update(s.recv(5).decode().endswith("1"))
          '';
        in {
          exec = "${pkgs.python311}/bin/python ${script}";
          return-type = "json";
        };

        "custom/screenshot" = {
          format = "";
          on-click = pkgs.writeShellScript "screenshot.sh" ''
            export PATH=${pkgs.lib.makeBinPath (with pkgs; [coreutils grim slurp wl-clipboard])}:$PATH
            grim -g "$(slurp)" - | wl-copy -t image/png
          '';
        };

        "custom/dunst" = {
          exec = pkgs.writeShellScript "dunst-is-paused" ''
            export PATH=${lib.makeBinPath (with pkgs; [coreutils dunst dbus])}

            set -euo pipefail

            readonly ENABLED=''
            readonly DISABLED=''
            dbus-monitor path='/org/freedesktop/Notifications',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged' --profile |
              while read -r _; do
                PAUSED="$(dunstctl is-paused)"
                if [ "$PAUSED" == 'false' ]; then
                  CLASS="enabled"
                  TEXT="$ENABLED"
                else
                  CLASS="disabled"
                  TEXT="$DISABLED"
                  COUNT="$(dunstctl count waiting)"
                  if [ "$COUNT" != '0' ]; then
                    TEXT="$DISABLED ($COUNT)"
                  fi
                fi
                printf '{"text": "%s", "class": "%s"}\n' "$TEXT" "$CLASS"
              done
          '';
          return-type = "json";
          on-click = pkgs.writeShellScript "dunst-toggle-paused.sh" ''
            dunstctl set-paused toggle
          '';
        };

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}{icon}";
          format-icons = {
            "0" = " ";
            "1" = " 󰖟";
            "2" = " ";
            "3" = " ";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = " ";
            "8" = " ";
            "9" = " ";
            "10" = " ";
            "42" = " ";
            "1337" = "";
            "+" = " ";
          };
        };

        "sway/scratchpad" = {
          format = "{icon} {count}";
          show-empty = false;
          format-icons = ["" ""];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };

        "tray" = {
          spacing = 8;
        };

        "backlight" = {
          format = "󰌵 {percent}%";
        };

        "battery" = {
          format = "{icon} {capacity}%{time}";
          format-charging = "󰂄 {capacity}%{time}";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-plugged = "󰚥 {capacity}%";
          format-time = " ({H}:{m})";
          states = {
            critical = 15;
            warning = 30;
          };
        };

        "clock" = {
          interval = 1;
          format = "󰃭 {:%Y-%m-%d 󰥔 %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          interval = 2;
          format = "󰘚 {usage}%";
          tooltip = false;
        };

        "memory" = {
          interval = 2;
          format = "󰍛 {avail} GB";
        };
        "memory#swap" = {
          interval = 2;
          format = "󰍛 {swapUsed} GB";
        };

        "disk" = mkDisk "/" "/";
        "disk#nix" = mkDisk "/nix" "/nix";
        "disk#persistent" = mkDisk "/persistent" "/persistent/data";

        "network" = {
          interval = 2;
          format-disconnected = "󰀦 Disconnected";
          format-ethernet = " {bandwidthTotalBytes} ({ipaddr})";
          format-wifi = " {essid} {signalStrength}% {bandwidthTotalBytes} ({ipaddr})";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-bluetooth = "{icon} 󰂯 {volume}%";
          format-bluetooth-muted = "󰖁 󰂯";
          format-icons = ["󰕿" "󰖀" "󰕾"];
        };

        "pulseaudio#mic" = {
          format = "{format_source}";
          format-muted = "{format_source}";
          format-bluetooth = "{format_source}";
          format-bluetooth-muted = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
        };
      };
    in
      {
        default =
          base
          // {
            output = lib.mkIf (conf.wayland.outputs.default.name != null) conf.wayland.outputs.default.name;

            modules-left = ["sway/workspaces" "sway/scratchpad"];
            modules-center = ["sway/window"];
            modules-right = ["custom/yk" "custom/screenshot" "memory" "memory#swap" "disk" "disk#nix" "disk#persistent" "cpu" "custom/dunst" "backlight" "pulseaudio" "pulseaudio#mic" "custom/webcam" "battery" "network" "clock" "tray"];
          };
      }
      // (builtins.mapAttrs (k: v:
        base
        // {
          name = k;
          height = 25;
          output = v.name;

          modules-left = ["sway/workspaces" "sway/scratchpad"];
          modules-center = [];
          modules-right = ["custom/yk" "memory" "memory#swap" "disk" "disk#nix" "disk#persistent" "cpu" "custom/dunst" "backlight" "pulseaudio" "pulseaudio#mic" "custom/webcam" "battery" "network" "clock"];
        }) (builtins.removeAttrs conf.wayland.outputs ["default"]));

    style = ''
      * {
          font-family: MesloLGS NF;
          font-size: 12px;
      }

      window#waybar {
          background-color: #1f1f1f;
          color: #ffffff;
          transition-property: box-shadow;
          transition-duration: 0.5s;
      }

      window#waybar.ext > * {
        margin-top: 5px;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      #workspaces button {
          padding: 0 12px;
          min-width: 0;
          color: #ffffff;
      }

      #workspaces button:hover {
          background: #282828;
          box-shadow: inset 0 -2px #00897b;
      }

      #workspaces button.focused {
          background-color: #333;
          box-shadow: inset 0 -2px #00b9ab;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #custom-dunst,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
          padding: 0 2px;
          margin: 0 4px;
          color: #ffffff;
      }

      @keyframes yk-blink {
        to {
          border: 2px solid transparent;
        }
      }

      #custom-yk {
        border: 2px solid #0f0;
        padding: 0 6px;
        margin: 0 4px;
        color: #fff;
        animation-name: yk-blink;
        animation-duration: 0.375s;
        animation-iteration-count: infinite;
        animation-timing-function: linear;
        animation-direction: alternate;
      }

      #custom-screenshot {
        padding: 0 5px;
        box-shadow: inset 0 -2px #fc5;
      }

      #window,
      #workspaces {
          margin: 0 4px;
      }

      #workspaces {
          margin-left: 0;
      }

      #clock {
          box-shadow: inset 0 -2px #0a7;
      }

      #battery {
          box-shadow: inset 0 -2px #c00;
          background: none;
      }

      #battery.charging, #battery.plugged {
          box-shadow: inset 0 -2px #26A65B;
      }

      #battery.warning:not(.charging) {
          background: #850;
      }
      #battery.critical:not(.charging) {
          background: #810;
      }

      #cpu {
          box-shadow: inset 0 -2px #2ecc71;
      }

      #memory {
          box-shadow: inset 0 -2px #9b59b6;
      }

      #disk {
          box-shadow: inset 0 -2px #6961ff;
      }
      #disk.warning {
          background: #850;
      }
      #disk.critical {
          background: #810;
      }

      #custom-dunst.enabled {
        box-shadow: inset 0 -2px #0a7;
      }
      #custom-dunst.disabled {
        box-shadow: inset 0 -2px #e00;
      }

      #backlight {
          box-shadow: inset 0 -2px #a0c1c1;
      }

      #network {
          box-shadow: inset 0 -2px #2980b9;
      }

      #network.disconnected {
          box-shadow: inset 0 -2px #e00;
      }

      #pulseaudio {
          box-shadow: inset 0 -2px #f1c40f;
      }

      #pulseaudio.muted:not(.mic), #pulseaudio.mic.source-muted {
          box-shadow: inset 0 -2px #880;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      #scratchpad.empty {
          background-color: transparent;
      }
    '';
  };
}
