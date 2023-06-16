{
  conf,
  config,
  pkgs,
  ...
}: {
  networking.hostName = conf.hostname;

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
    dispatcherScripts = [
      {
        type = "basic";
        source = let
          vpn.default = config.sops.secrets."networking/vpn/default".path;
          vpn.full = config.sops.secrets."networking/vpn/full".path;
          wifi.trusted = config.sops.secrets."networking/wifi/trusted".path;
          nmcli = "${pkgs.networkmanager}/bin/nmcli";
          is_trusted = ''${pkgs.gnugrep}/bin/grep -q "^$CONNECTION_UUID$" ${wifi.trusted}'';
        in
          pkgs.writeText "trusted-networks" ''
            if ${is_trusted}; then
              if [[ "$2" = "up" ]]; then
                ${nmcli} c up "$(${pkgs.coreutils}/bin/cat ${vpn.default})";
              else
                ${nmcli} c up "$(${pkgs.coreutils}/bin/cat ${vpn.full})";
              fi
            fi
          '';
      }
    ];
  };

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      22000 # syncthing
    ];
    allowedUDPPorts = [];
    trustedInterfaces = ["docker0" "vpn"];

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

  sops.secrets = let
    dir = ../hosts/${conf.hostname}/secrets/nm-connections;
  in
    builtins.listToAttrs (builtins.map (name: {
      name = "networking/nm-connection-${name}.nmconnection";
      value = {
        format = "binary";
        sopsFile = /${dir}/${name};
        path = "/etc/NetworkManager/system-connections/${name}.nmconnection";
      };
    }) (builtins.attrNames (builtins.readDir dir)))
    // {
      "networking/vpn/default" = {};
      "networking/vpn/full" = {};
      "networking/wifi/trusted" = {};
    };
}
