{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      UsePAM = false;
    };
    hostKeys = [
      {
        type = "ed25519";
        path = "/persistent/cache/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  programs.ssh.knownHosts = {
    "*.your-storagebox.de" = {
      extraHostNames = [ "[*.your-storagebox.de]:23" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
    };
  };
}
