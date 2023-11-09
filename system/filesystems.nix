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
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime"];
    };

    "/persistent/data" = {
      device = "/dev/nixos/persistent";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime" "subvol=@data"];
    };

    "/persistent/cache" = {
      device = "/dev/nixos/persistent";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime" "subvol=@cache"];
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
