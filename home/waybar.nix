{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 20;
        fixed-center = false;

        modules-left = ["sway/workspaces" "sway/scratchpad"];
        modules-center = ["sway/window"];
        modules-right = [
          "custom/yk"
          "custom/screenshot"
          "memory"
          "cpu"
          "custom/dunst"
          "backlight"
          "pulseaudio"
          "custom/webcam"
          "battery"
          "network"
          "clock"
          "tray"
        ];

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
          spacing = 10;
        };

        "backlight" = {
          format = "󰌵 {percent}%";
        };

        "battery" = {
          format = "{icon} {capacity}% ({time})";
          format-charging = "󰂄 {capacity}% ({time})";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          format-plugged = "󰚥 {capacity}%";
          states = {
            critical = 15;
            warning = 30;
          };
        };

        "clock" = {
          interval = 1;
          format = "{:󰃭 %Y-%m-%d 󰥔 %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        "cpu" = {
          interval = 2;
          format = "󰘚 {usage}%";
          tooltip = false;
        };

        "memory" = {
          interval = 2;
          format = "󰍛 {avail}GB / {swapUsed}GB";
        };

        "network" = {
          interval = 2;
          format-disconnected = "󰀦 Disconnected";
          format-ethernet = " {bandwidthTotalBytes} ({ipaddr})";
          format-wifi = " {essid} {signalStrength}% {bandwidthTotalBytes} ({ipaddr})";
        };

        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-muted = "󰖁 {format_source}";
          format-bluetooth = "{icon}󰂯 {volume}% {format_source}";
          format-bluetooth-muted = "󰖁 󰂯 {format_source}";
          format-icons = ["󰕿" "󰖀" "󰕾"];
          format-source = "󰍬 {volume}%";
          format-source-muted = "󰍭";
        };
      };
    };

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
      }

      #battery.charging, #battery.plugged {
          box-shadow: inset 0 -2px #26A65B;
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
      }

      #cpu {
          box-shadow: inset 0 -2px #2ecc71;
      }

      #memory {
          box-shadow: inset 0 -2px #9b59b6;
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

      #pulseaudio.muted {
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
