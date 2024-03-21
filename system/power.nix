{pkgs, ...}: {
  services.upower = {
    enable = true;
  };
  powerManagement.powertop.enable = true;
  services.tlp.enable = true;
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=hibernate
    '';
  };
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=120m
  '';

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
