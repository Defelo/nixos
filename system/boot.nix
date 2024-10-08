{
  config,
  pkgs,
  lanzaboote,
  lib,
  ...
}: {
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.timeout = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  # https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  environment.systemPackages = with pkgs; [efibootmgr sbctl];

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.swappiness" = 1;
  };

  boot.supportedFilesystems = ["ntfs"];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [config.boot.kernelPackages.rtl8821ce];

  boot.initrd.kernelModules = ["vfat" "nls_cp437" "nls_iso8859-1" "usbhid"];

  boot.blacklistedKernelModules = ["uvcvideo" "rtw88_8821ce"];
}
