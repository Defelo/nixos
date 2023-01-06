{pkgs, ...}: {
  networking.hostName = "nitrogen";

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      22000 # syncthing
    ];
    allowedUDPPorts = [];
    trustedInterfaces = ["docker0"];
  };

  environment.etc = with pkgs.lib.attrsets;
    mapAttrs'
    (name: value:
      nameValuePair ("NetworkManager/system-connections/" + name + ".nmconnection") {
        text = value;
        mode = "0400";
      })
    (import ../secrets.nix).nm.connections;
}
