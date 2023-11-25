{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "Fri 07:00";
    fileSystems = [
      "/dev/nixos/persistent"
      "/nix"
    ];
  };
}
