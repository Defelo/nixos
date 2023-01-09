{pkgs, ...}: {
  services.picom = {
    enable = true;
    backend = "xr_glx_hybrid";
    extraArgs = ["--transparent-clipping"];
    fade = true;
    fadeDelta = 4;
    fadeSteps = [0.055 0.055];
    shadow = true;
    vSync = true;
    activeOpacity = 1;
    inactiveOpacity = 0.9;
    opacityRules = let
      rules = {
        Alacritty = 95;
        thunderbird = 90;
        discord = 90;
        Element = 90;
        TelegramDesktop = 95;
        obsidian = 95;
      };
    in
      pkgs.lib.attrsets.mapAttrsToList (key: value: "${toString value}:class_g = '${key}'") rules;
    settings = {
      corner-radius = 4;
    };
  };
}
