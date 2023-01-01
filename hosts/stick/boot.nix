{...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernel.sysctl."kernel.sysrq" = 1;

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "breeze";

  boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/5b3c0b4f-803a-41c5-8283-0cd88face4da";
    preLVM = true;
    yubikey = {
      slot = 2;
      twoFactor = true;
      storage.device = "/dev/disk/by-uuid/5D1A-6283";
      storage.fsType = "vfat";
      storage.path = "/crypt-storage/default";
    };
  };

  boot.blacklistedKernelModules = ["uvcvideo"];
}
