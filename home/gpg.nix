{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings.trust-model = "tofu+pgp";
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-driver = "${pkgs.pcsclite.lib}/lib/libpcsclite.so.1";
      card-timeout = "1";
      reader-port = "Yubico YubiKey";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    enableSshSupport = true;
    sshKeys = [ "D2277B1C3C924964972148EF590B9F083697F9A8" ];
    enableExtraSocket = true;
  };
}
