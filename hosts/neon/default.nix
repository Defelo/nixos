_: {
  system = "x86_64-linux";

  partitions = {
    boot = "/dev/disk/by-uuid/A28F-4707";
    crypt = "/dev/disk/by-uuid/b74a3f01-cba6-4912-bb38-14221a136cd0";
  };

  wayland.outputs = {
    default = {
      name = "eDP-1";
      pos = "1280,0";
      mode = "2560x1600";
      scale = "1.25";
      touch = true;
      workspaces = null;
    };
    ext = {
      name = "HDMI-A-1";
      pos = "0,0";
      mode = "1280x1024";
      scale = "1";
      touch = false;
      workspaces = ["0"];
    };
  };

  borg.excludeSyncthing = false;

  extraConfig = {
    # https://forums.lenovo.com/t5/Ubuntu/Yoga-7i-sound-card-issue-on-Linux/m-p/5183746?page=1#5807792
    boot.extraModprobeConfig = ''
      options snd-sof-intel-hda-common hda_model=alc287-yoga9-bass-spk-pin
    '';

    boot.loader.grub.extraEntries = ''
      menuentry "NixOS Live ISO" {
        set root=(hd0,gpt6)
        chainloader /EFI/boot/bootx64.efi
      }
    '';
  };
}
