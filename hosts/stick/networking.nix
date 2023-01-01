{pkgs, ...}: {
  networking.hostName = "nixos-stick";

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  environment.etc = with pkgs.lib.attrsets;
    mapAttrs'
    (name: value:
      nameValuePair ("NetworkManager/system-connections/" + name + ".nmconnection") {
        text = value;
        mode = "0400";
      })
    (import ../../secrets.nix).nm.connections;
}
