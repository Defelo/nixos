{pkgs, ...}: {
  services.polybar = let
    polybar = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
  in {
    enable = true;
    script = let
      dependencies = with pkgs; [polybar coreutils-full gnugrep dbus i3-gaps dunst bluez kmod alacritty upower];
    in ''
      (
        export PATH=${pkgs.lib.makeBinPath dependencies}
        while ! i3-msg -q; do sleep .1; done
        polybar
      ) &
    '';
    package = polybar;
    settings = let
      trans = "#00000000";
      white = "#FFFFFF";
      black = "#000000";

      bg = "#1F1F1F";
      fg = "#FFFFFF";
      fg-alt = "#A9ABB0";

      acolor = "#00897b";
      curgent = "#e53935";
      coccupied = "#039be5";

      red = "#e53935";
      pink = "#d81b60";
      purple = "#8e24aa";
      deep-purple = "#5e35b1";
      indigo = "#3949ab";
      blue = "#1e88e5";
      light-blue = "#039be5";
      cyan = "#00acc1";
      teal = "#00897b";
      green = "#43a047";
      light-green = "#7cb342";
      lime = "#c0ca33";
      yellow = "#fdd835";
      amber = "#ffb300";
      orange = "#fb8c00";
      deep-orange = "#f4511e";
      brown = "#6d4c41";
      grey = "#757575";
      blue-gray = "#546e7a";

      modules = builtins.concatStringsSep " ";
    in {
      "bar/main" = {
        enable-ipc = true;
        width = "100%";
        height = 20;
        offset-x = "0%";
        offset-y = "0%";
        bottom = false;
        fixed-center = false;
        line-size = 2;

        background = bg;
        foreground = fg;

        border-size = 3;
        border-color = bg;

        module-margin-left = 1;
        module-margin-right = 1;

        font = [
          "Fantasque Sans Mono:pixelsize=10;2"
          "Material Icons:pixelsize=10;4"
          "Font Awesome 5 Free:pixelsize=9;3"
          "Font Awesome 5 Free Solid:pixelsize=9;3"
          "Font Awesome 5 Brands:pixelsize=9;3"
        ];

        cursor-click = "pointer";

        tray-position = "right";
        tray-padding = 1;

        scroll-up = "i3wm-wsprev";
        scroll-down = "i3wm-wsnext";

        modules-left = modules ["workspaces" "window" "scratch"];
        modules-center = modules [];
        modules-right = modules [
          "screenshot"
          "mem"
          "swap"
          "cpu"
          "dunst"
          "volume"
          "webcam"
          "battery"
          "btpower"
          "network-wired"
          "network-wireless"
          "date"
        ];
      };
      "module/workspaces" = {
        type = "internal/i3";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = true;
        wrapping-scroll = false;
        format-padding = 0;

        format = "<label-state> <label-mode>";
        label-focused = "%name%";
        label-urgent = "%name%";
        label-unfocused = "%name%";

        label-focused-padding = 1;
        label-urgent-padding = 1;
        label-unfocused-padding = 1;

        label-focused-foreground = acolor;
        label-urgent-foreground = curgent;
        label-unfocused-foreground = fg;

        label-focused-underline = acolor;
        label-urgent-underline = curgent;
      };
      "module/window" = {
        type = "internal/xwindow";
        label = "%title:0:30:...%";
        format-underline = acolor;
        format-foreground = fg-alt;
      };
      "module/scratch" = {
        type = "custom/script";
        exec = ''"cnt=$(i3-msg -t get_tree | grep -o '"scratchpad_state":"fresh"' | wc -l);[ $cnt = 0 ] && echo %{u#000}%{-u} || echo +''${cnt}"'';
        interval = 1;
        format-underline = acolor;
      };
      # "module/yk" =
      #   let
      #     script = builtins.toFile "yktd.py" ''
      #       import socket, os
      #       s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
      #       s.connect(f"/run/user/{os.getuid()}/yubikey-touch-detector.socket")
      #       def update(touch):
      #         print(""*touch, flush=True)
      #         os.system(f"polybar-msg action yk module_{['hide','show'][touch]} > /dev/null")
      #       update(False)
      #       while True: update(s.recv(5).decode().endswith("1"))
      #     ''; in
      #   {
      #     type = "custom/script";
      #     exec = "${pkgs.python311}/bin/python ${script}";
      #     tail = true;
      #   };
      "module/screenshot" = {
        type = "custom/text";
        content = "";
        click-left = "${pkgs.flameshot}/bin/flameshot gui -c";
      };
      "module/mem" = {
        type = "internal/memory";
        interval = 2;
        label = "%free%";
      };
      "module/swap" = {
        type = "internal/memory";
        interval = 2;
        label = "%swap_used%";
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 1;
        label = "%percentage%%";
        format-underline = acolor;
      };
      "module/dunst" = {
        type = "custom/script";
        exec = ''"[ true = $(dunstctl is-paused) ] && echo %{u#000}%{-u} || echo "'';
        interval = 1;
        format-underline = acolor;
        click-left = "dunstctl set-paused toggle";
      };
      "module/volume" = {
        type = "internal/pulseaudio";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        format-muted-prefix = " ";
        label-muted = "MUTE";

        format-volume-underline = acolor;

        ramp-volume = ["" "" "" "" "" "" ""];
      };
      "module/webcam" = {
        type = "custom/script";
        exec = ''"lsmod | grep -q uvcvideo && echo "" || echo %{u#000}%{-u}%{F#999}"'';
        click-left = ''"alacritty -e sudo modprobe $(lsmod | grep -q uvcvideo && echo -r) uvcvideo"'';
        format-underline = acolor;
        interval = 10;
      };
      "module/battery" = {
        type = "internal/battery";
        full-at = 100;
        time-format = "%H:%M";
        battery = "BAT0";
        adapter = "AC";

        format-charging = "<animation-charging> <label-charging>";
        label-charging = "%percentage%% (%time%)";
        format-charging-underline = acolor;

        format-discharging = "<ramp-capacity> <label-discharging>";
        label-discharging = "%percentage%% (%time%)";

        format-full = "<label-full>";
        label-full = "%percentage%%";
        format-full-prefix = " ";

        ramp-capacity = ["" "" "" "" ""];

        ramp-capacity-0-foreground = red;
        ramp-capacity-foreground = fg;
        bar-capacity-width = 10;

        animation-charging = ["" "" "" "" ""];

        animation-charging-framerate = 750;
      };
      "module/btpower" = let
        script = builtins.toFile "btpower.sh" ''
          mac=$(bluetoothctl devices Connected | cut -d' ' -f2 | tr : _)
          [[ -n "$mac" ]] && path=$(upower -e | grep $mac)
          [[ -n "$path" ]] && res=$(upower -i "$path" | grep percentage | awk '{print $2}')
          res=''${res:-0%}
          polybar-msg action btpower module_$([[ "$res" != "0%" ]] && echo show || echo hide) > /dev/null
          echo " $res"
        '';
      in {
        type = "custom/script";
        exec = "${pkgs.bash}/bin/bash ${script}";
        interval = 10;
      };
      "module/network-wired" = {
        type = "internal/network";
        interface-type = "wired";
        unknown-as-up = true;
        interval = 2;

        format-connected = "<label-connected>";
        label-connected = " %netspeed% (%local_ip%)";
        format-connected-underline = acolor;

        format-disconnected = "<label-disconnected>";
        label-disconnected = "";
      };
      "module/network-wireless" = {
        type = "internal/network";
        interface-type = "wireless";
        interval = 2;

        format-connected = "<label-connected>";
        label-connected = " %essid% %signal%% %netspeed% (%local_ip%)";
        format-connected-underline = acolor;

        format-disconnected = "<label-disconnected>";
        label-disconnected = "";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        label = "%date% %time%";
        time = " %H:%M:%S";
        date = " %Y-%m-%d";
      };
    };
  };
}
