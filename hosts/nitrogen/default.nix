_: {
  system = "x86_64-linux";

  partitions = {
    boot = "/dev/disk/by-uuid/3476-D46E";
    crypt = "/dev/disk/by-uuid/bcedff9c-e5a0-4a07-84b2-1fa454aeab7f";
  };

  sway.output.scale = "1.0";

  borg.excludeSyncthing = true;

  extraConfig = {
    imports = [
      ../../system/zram.nix
    ];
  };
}
