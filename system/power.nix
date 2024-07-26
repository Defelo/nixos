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
  systemd.services.powertop.postStart = ''
    cd /sys/bus/usb/devices
    for f in *; do
      if [[ -e "$f/product" ]] && [[ "$(cat $f/product)" = "USB OPTICAL MOUSE " ]]; then
        echo on > "$f/power/control"
      fi
    done
  '';

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
