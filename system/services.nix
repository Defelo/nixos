{
  pkgs,
  pkgs-old,
  ...
}: {
  imports = [
    ./pcscd.nix
  ];

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
  services.pcscd.package = pkgs-old.pcscliteWithPolkit;

  programs.ssh.startAgent = false;

  programs.dconf.enable = true;

  services.udev.packages = [pkgs.yubikey-personalization];
}
