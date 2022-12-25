{...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "breeze";

  # boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
  # boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-label/crypt";
    preLVM = true;
    # yubikey = {
    #   slot = 2;
    #   twoFactor = true;
    #   storage.device = "/dev/vda1";
    #   storage.fsType = "vfat";
    #   storage.path = "/crypt-storage/default";
    # };
  };
}
