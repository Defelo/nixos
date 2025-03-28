{ conf, impermanence, ... }:
{
  imports = [ impermanence.nixosModule ];

  environment.persistence."/persistent/data" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/root/.ssh"
      "/var/lib/bluetooth"
    ];
    files = [ ];

    users.${conf.user} = (import ../home/persistence.nix).data;
  };

  environment.persistence."/persistent/cache" = {
    hideMounts = true;
    directories = [
      "/root/.cache/nix"
      "/var/lib/btrfs"
      "/var/lib/libvirt"
      "/var/lib/nixos"
      "/var/lib/sbctl"
      "/var/lib/systemd/backlight"
      "/var/lib/systemd/timers"
      # "/var/lib/waydroid"
      "/var/log"
    ];
    files = [ "/etc/machine-id" ];

    users.${conf.user} = (import ../home/persistence.nix).cache;
  };
}
