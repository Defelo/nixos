{
  conf,
  pkgs,
  ...
} @ inputs: {
  xsession = {
    enable = true;
    scriptPath = ".xinitrc";
    initExtra = ''
      # disable screensaver
      xset s off
      xset -dpms
      xset s noblank

      # set wallpaper
      ${pkgs.feh}/bin/feh --bg-scale ${../wallpapers/default.png}

      # lock screen on suspend/hibernate
      ${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${conf.lock-command} &

      # start clipman
      PATH=${pkgs.xfce.xfce4-clipman-plugin}/bin:$PATH xfce4-clipman &

      # fix keyboard layout
      setxkbmap de nodeadkeys

      # start some applications
      brave &
      thunderbird &
      discordcanary &
      element-desktop &
      telegram-desktop &
      obsidian &
      alacritty &
    '';
    windowManager.i3 = import ./i3.nix inputs;
  };
}
