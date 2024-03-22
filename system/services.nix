{pkgs, ...}: {
  virtualisation.podman = {
    enable = true;
  };

  services.pcscd.enable = true;

  programs.ssh.startAgent = false;

  programs.dconf.enable = true;

  services.udev.packages = [pkgs.yubikey-personalization];

  programs.mtr.enable = true;
}
