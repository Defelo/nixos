{nixpkgs, ...}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {inherit system;};
in rec {
  inherit system;
  hostname = "neon";
  uid = 1000;
  user = "felix";
  home = "/home/${user}";

  partitions = {
    boot = "/dev/disk/by-uuid/A28F-4707";
    crypt = "/dev/disk/by-uuid/b74a3f01-cba6-4912-bb38-14221a136cd0";
  };

  ykfde = false;

  sway.output.scale = "1.25";

  borg.excludeSyncthing = false;

  lock-command = builtins.concatStringsSep " " [
    "${pkgs.swaylock-effects}/bin/swaylock"
    "--screenshots"
    "--clock"
    "--submit-on-touch"
    "--show-failed-attempts"
    "--effect-pixelate 8"
    "--fade-in 0.5"
  ];

  extraConfig = {};

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

    fileSystems."/" = {
      device = "/dev/nixos/root";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = partitions.boot;
      fsType = "vfat";
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
