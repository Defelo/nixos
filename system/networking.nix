{
  conf,
  pkgs,
  ...
}: {
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = let
        inherit (conf.networking) vpn;
        wifi.trusted = builtins.toFile "wifi-trusted" (builtins.foldl' (acc: x: "${acc}${x}\n") "" conf.networking.wifi.trusted);
      in
        pkgs.writeText "trusted-networks" ''
          export PATH=${pkgs.lib.makeBinPath (with pkgs; [coreutils gnugrep networkmanager])}

          if [[ -z "$1" ]] || [[ "$1" = "vpn" ]]; then
            exit
          fi

          if nmcli --fields=UUID c s --active | tail +2 | cut -d' ' -f1 | sort | comm -12 - <(sort ${wifi.trusted}) | grep -q .; then
            nmcli c up "${vpn.default}" &
          else
            nmcli c up "${vpn.full}" &
          fi
        '';
    }
  ];

  networking.firewall = {
    enable = true;
    allowPing = false;
    allowedTCPPorts = [
      22000 # syncthing
    ];
    allowedUDPPorts = [];
    trustedInterfaces = ["vpn"];

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
    }) (builtins.attrNames (builtins.removeAttrs (builtins.readDir dir) [".gitkeep"])))
    // {
      "networking/uni-wifi-keys/client_cert.pem" = {
        format = "binary";
        sopsFile = ../hosts/${conf.hostname}/secrets/uni-wifi-keys/client_cert.pem;
      };
      "networking/uni-wifi-keys/client_key.pem" = {
        format = "binary";
        sopsFile = ../hosts/${conf.hostname}/secrets/uni-wifi-keys/client_key.pem;
      };
      "networking/uni-wifi-keys/root_ca.pem" = {
        format = "binary";
        sopsFile = ../hosts/${conf.hostname}/secrets/uni-wifi-keys/root_ca.pem;
      };
    };
}
