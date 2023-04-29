{...}: {
  services.redshift = {
    enable = true;
    tray = true;
    provider = "geoclue2";
    temperature = {
      day = 6500;
      night = 4000;
    };
    settings.redshift = {
      brightness-day = 1.0;
      brightness-night = 0.7;
    };
  };
}
