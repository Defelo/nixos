{...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 4;
    fadeSteps = [0.055 0.055];
    shadow = true;
    vSync = true;
    inactiveOpacity = 0.9;
  };
}
