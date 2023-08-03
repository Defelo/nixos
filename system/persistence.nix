{
  conf,
  impermanence,
  ...
}: {
  imports = [impermanence.nixosModule];

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/root/.cache/nix"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/backlight"
      "/var/lib/systemd/timers"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
    ];

    users.${conf.user} = import ../home/persistence.nix;
  };
}
