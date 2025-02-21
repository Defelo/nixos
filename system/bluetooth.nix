{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    settings.General.Experimental = true;
  };

  systemd.services.bluetooth.preStart = ''
    ${pkgs.util-linux}/bin/rfkill unblock bluetooth
  '';
}
