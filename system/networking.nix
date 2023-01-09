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

    # disable rpfilter for wireguard
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
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
