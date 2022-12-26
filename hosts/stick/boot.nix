{...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = false;

  # boot.plymouth.enable = true;
  # boot.plymouth.theme = "breeze";

  # boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
  # boot.initrd.luks.yubikeySupport = true;
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/db14ee0a-e88f-4291-a30a-a8280a078133";
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
