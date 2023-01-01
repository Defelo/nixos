{...}: {
  services.upower = {
    enable = true;
  };
  powerManagement.powertop.enable = true;
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
  '';
}
