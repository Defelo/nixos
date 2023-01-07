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
      ${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- ${pkgs.i3lock-fancy}/bin/i3lock-fancy -pt "" &
      PATH=${pkgs.xfce.xfce4-clipman-plugin}/bin:$PATH xfce4-clipman &
      setxkbmap de nodeadkeys
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
