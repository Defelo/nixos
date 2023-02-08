{...}: {
  # services.printing.enable = true;

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.openssh.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features.buildkit = true;
    };
  };

  services.pcscd.enable = true;

  programs.ssh.startAgent = false;

  programs.dconf.enable = true;
}
