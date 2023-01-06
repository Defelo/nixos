{...}: {
  services.redshift = with (import ../secrets.nix).location; {
    enable = true;
    tray = true;
    inherit latitude longitude;
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
