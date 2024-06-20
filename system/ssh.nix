{
  programs.ssh.knownHosts = {
    "*.your-storagebox.de" = {
      extraHostNames = ["[*.your-storagebox.de]:23"];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
    };
  };
}
