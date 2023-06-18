{nixpkgs, ...}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {inherit system;};
in rec {
  inherit system;
  hostname = "nitrogen";
  uid = 1000;
  user = "felix";
  home = "/home/${user}";

  partitions = {
    boot = "/dev/disk/by-uuid/3476-D46E";
    crypt = "/dev/disk/by-uuid/bcedff9c-e5a0-4a07-84b2-1fa454aeab7f";
  };

  ykfde = false;

  sway.output.scale = "1.0";

  lock-command = builtins.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--screenshots"
    "--clock"
    "--submit-on-touch"
    "--show-failed-attempts"
    "--effect-pixelate 8"
    "--fade-in 0.5"
  ];

  extraConfig = {
    imports = [
      ../../system/zram.nix
    ];
  };

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
