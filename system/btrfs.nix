{
  services.btrfs.autoScrub = {
    enable = true;
    interval = "Fri 07:00";
    fileSystems = [
      "/dev/nixos/persistent"
      "/nix"
    ];
  };

  services.snapper = {
    snapshotInterval = "*:0/5";
    cleanupInterval = "1h";
    configs = {
      data = {
        SUBVOLUME = "/persistent/data";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 2 * 3600;
        TIMELINE_LIMIT_HOURLY = 10;
        TIMELINE_LIMIT_DAILY = 10;
        TIMELINE_LIMIT_WEEKLY = 10;
        TIMELINE_LIMIT_MONTHLY = 10;
        TIMELINE_LIMIT_YEARLY = 10;
      };
      cache = {
        SUBVOLUME = "/persistent/cache";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_MIN_AGE = 30 * 60;
        TIMELINE_LIMIT_HOURLY = 4;
        TIMELINE_LIMIT_DAILY = 3;
        TIMELINE_LIMIT_WEEKLY = 2;
        TIMELINE_LIMIT_MONTHLY = 0;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
