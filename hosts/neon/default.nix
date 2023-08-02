{impermanence, ...}: rec {
  system = "x86_64-linux";
  uid = 1000;
  user = "felix";
  home = "/home/${user}";

  partitions = {
    boot = "/dev/disk/by-uuid/A28F-4707";
    crypt = "/dev/disk/by-uuid/b74a3f01-cba6-4912-bb38-14221a136cd0";
  };

  sway.output.scale = "1.25";

  borg.excludeSyncthing = false;

  extraConfig = {
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

      users.${user} = {
        directories = [
          ".cache/nix"
          ".cache/spotify"
          ".cargo"
          ".config/BraveSoftware"
          ".config/Element"
          ".config/Signal Beta"
          ".config/Signal"
          ".config/Slack"
          ".config/dconf"
          ".config/discordcanary"
          ".config/fcitx5"
          ".config/gh"
          ".config/obsidian"
          ".config/spotify"
          ".config/syncthing"
          ".gnupg"
          ".local/share/TelegramDesktop"
          ".local/share/direnv/allow"
          ".local/state/wireplumber"
          ".password-store"
          ".ssh"
          ".thunderbird"
          ".timetracker"
          ".yubico"

          "nixos"
          "Persistent"
        ];
        files = [];
      };
    };
  };

  hardware-configuration = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci"];
    boot.initrd.kernelModules = ["dm-snapshot"];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    # https://forums.lenovo.com/t5/Ubuntu/Yoga-7i-sound-card-issue-on-Linux/m-p/5183746?page=1#5807792
    boot.extraModprobeConfig = ''
      options snd-sof-intel-hda-common hda_model=alc287-yoga9-bass-spk-pin
    '';

    fileSystems = {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = ["defaults" "size=4G" "mode=755"];
      };

      "/persistent" = {
        device = "/dev/nixos/root";
        fsType = "ext4";
        neededForBoot = true;
      };

      "/boot" = {
        device = partitions.boot;
        fsType = "vfat";
      };

      "/nix" = {
        device = "/persistent/nix";
        options = ["bind"];
      };
    };

    swapDevices = [
      {
        device = "/dev/nixos/swap";
        priority = 0;
      }
    ];

    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault system;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
