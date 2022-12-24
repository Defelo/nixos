{ ... }:

{
  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = ../keys/defelo.pub;
        trust = 5;
      }
      {
        source = ../keys/private.pub;
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
