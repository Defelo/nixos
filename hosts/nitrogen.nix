{...}: rec {
  system = "x86_64-linux";
  hostname = "nitrogen";
  uid = 1000;
  user = "felix";
  home = "/home/${user}";

  partitions = {
    boot = "/dev/disk/by-uuid/3476-D46E";
    crypt = "/dev/disk/by-uuid/acabf7fe-1a29-47cd-8e10-9b8f88f936d4";
  };

  ykfde = false;

  hardware-configuration = {
    config,
    lib,
    pkgs,
    modulesPath,
    ...
  }: {
    imports = [(modulesPath + "/installer/scan/not-detected.nix")];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/nixos/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = partitions.boot;
      fsType = "vfat";
    };

    fileSystems."/mnt/arch" = {
      device = "/dev/mapper/arch";
      fsType = "ext4";
      encrypted = {
        enable = true;
        blkDev = "/dev/disk/by-uuid/189f0f8c-336a-4029-9a46-f894f0022b58";
        keyFile = "/mnt-root/root/.arch.key";
        label = "arch";
      };
    };

    swapDevices = [
      {
        device = "/dev/nixos/swap";
        priority = 0;
      }
    ];

    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault system;
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
