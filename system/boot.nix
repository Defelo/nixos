{
  conf,
  lib,
  ...
}: {
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
  boot.initrd.luks.yubikeySupport = conf.ykfde;
  boot.initrd.luks.devices.root = {
    device = conf.partitions.crypt;
    preLVM = true;
    yubikey = lib.mkIf conf.ykfde {
      slot = 2;
      twoFactor = true;
      storage.device = conf.partitions.boot;
      storage.fsType = "vfat";
      storage.path = "/crypt-storage/default";
    };
  };

  boot.blacklistedKernelModules = ["uvcvideo"];
}
