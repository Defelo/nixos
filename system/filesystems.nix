{conf, ...}: let
  inherit (conf) partitions tmpfsSize;
in {
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["defaults" "size=${tmpfsSize}" "mode=755"];
    };

    "/nix" = {
      device = "/dev/nixos/nix";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/persistent/data" = {
      device = "/dev/nixos/data";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/persistent/cache" = {
      device = "/dev/nixos/cache";
      fsType = "ext4";
      neededForBoot = true;
    };

    "/boot" = {
      device = partitions.boot;
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/dev/nixos/swap";
      priority = 0;
    }
  ];
}
