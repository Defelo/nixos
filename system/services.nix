{pkgs, ...}: {
  # services.printing.enable = true;

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  virtualisation.podman = {
    enable = true;
  };

  services.pcscd.enable = true;

  programs.ssh.startAgent = false;

  programs.dconf.enable = true;

  services.udev.packages = [pkgs.yubikey-personalization];
}
