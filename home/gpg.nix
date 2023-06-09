{...}: {
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gtk2";
    enableSshSupport = true;
    sshKeys = ["D2277B1C3C924964972148EF590B9F083697F9A8"];
    enableExtraSocket = true;
  };
}
