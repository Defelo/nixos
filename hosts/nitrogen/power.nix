{...}: {
  services.upower = {
    enable = true;
  };
  powerManagement.powertop.enable = true;
  services.logind = {
    # lidSwitch = "suspend-then-hibernate";
    lidSwitch = "suspend";
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };
  # systemd.sleep.extraConfig = ''
  #   HibernateDelaySec=30m
  # '';
}
