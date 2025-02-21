{
  services.gammastep = {
    enable = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 4000;
    };
    settings.general = {
      brightness-day = 1.0;
      brightness-night = 0.7;
    };
  };
}
