{...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "breeze";

  boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/acabf7fe-1a29-47cd-8e10-9b8f88f936d4";
    preLVM = true;
    yubikey = {
      slot = 2;
      twoFactor = true;
      storage.device = "/dev/disk/by-uuid/3476-D46E";
      storage.fsType = "vfat";
      storage.path = "/crypt-storage/default";
    };
  };

  boot.blacklistedKernelModules = ["uvcvideo"];
}
