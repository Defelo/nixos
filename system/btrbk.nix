{
  services.btrbk = {
    instances.data = {
      onCalendar = "*:0/5";
      settings = {
        volume."/persistent/data" = {
          snapshot_preserve_min = "2h";
          snapshot_preserve = "24h 7d";
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };

    instances.cache = {
      onCalendar = "*:0/5";
      settings = {
        volume."/persistent/cache" = {
          snapshot_preserve_min = "1h";
          snapshot_preserve = "24h 7d";
          subvolume = ".";
          snapshot_dir = ".snapshots";
        };
      };
    };
  };
}
