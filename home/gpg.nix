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
    sshKeys = ["D2277B1C3C924964972148EF590B9F083697F9A8"];
    enableExtraSocket = true;
  };
}
