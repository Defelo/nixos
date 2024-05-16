{
  conf,
  config,
  pkgs-rtl8821ce,
  ...
}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = false;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.swappiness" = 1;
  };

  boot.supportedFilesystems = ["ntfs"];

  boot.kernelPackages = pkgs-rtl8821ce.linuxPackages_latest;
  boot.extraModulePackages = [config.boot.kernelPackages.rtl8821ce];

  boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];
  boot.initrd.luks.devices.root = {
    device = conf.partitions.crypt;
    preLVM = true;
  };

  boot.blacklistedKernelModules = ["uvcvideo" "rtw88_8821ce"];
}
