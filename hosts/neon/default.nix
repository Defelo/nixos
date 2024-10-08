{
  _module.args.conf = {
    user = "felix";

    networking = {
      vpn.default = "72ab4eb3-3c9a-42c9-adeb-9f4730d540e6";
      vpn.full = "bb1d4d42-dedb-4598-8b81-d2147b3197ab";
      wifi.trusted = [
        "fad97450-a66a-44f9-894b-19d578ba6265"
        "9a3a989a-c30b-4b2c-be19-28094e503bf2"
        "ffb7f072-ae29-3ade-9b4f-29eec0ff1324"
      ];
      secrets = ./secrets;
    };

    wayland.outputs = {
      default = {
        name = "eDP-1";
        pos = "0,0"; # primary output should start at 0,0
        mode = "2560x1600";
        scale = "1.25";
        touch = true;
        workspaces = null;
      };
      ext = {
        name = "HDMI-A-1";
        pos = "-1280,0";
        mode = "1280x1024";
        scale = "1";
        touch = false;
        workspaces = ["0"];
      };
    };
  };

  boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/4500f286-2548-47a5-9432-d24cb032063b";

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["defaults" "size=100%" "mode=755"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/5ad67c07-d42c-4871-b2ea-f4ea30121666";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime" "subvol=@nix"];
    };

    "/persistent/data" = {
      device = "/dev/disk/by-uuid/5ad67c07-d42c-4871-b2ea-f4ea30121666";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime" "subvol=@data"];
    };

    "/persistent/cache" = {
      device = "/dev/disk/by-uuid/5ad67c07-d42c-4871-b2ea-f4ea30121666";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["compress=zstd" "noatime" "subvol=@cache"];
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/5ad67c07-d42c-4871-b2ea-f4ea30121666";
      fsType = "btrfs";
      neededForBoot = true;
      options = ["noatime" "subvol=@swap"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6B80-B69E";
      fsType = "vfat";
      options = ["umask=0077"];
    };
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      priority = 0;
    }
  ];
  boot.kernelParams = ["resume_offset=14754000"];

  # https://forums.lenovo.com/t5/Ubuntu/Yoga-7i-sound-card-issue-on-Linux/m-p/5183746?page=1#5807792
  boot.extraModprobeConfig = ''
    options snd-sof-intel-hda-common hda_model=alc287-yoga9-bass-spk-pin
  '';
}
