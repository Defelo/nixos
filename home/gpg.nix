{...}: {
  programs.gpg = {
    enable = true;
    publicKeys = with import ../secrets.nix; [
      {
        text = gpg.defelo;
        trust = 5;
      }
      {
        text = gpg.private;
        trust = 5;
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSshSupport = true;
  };
}
