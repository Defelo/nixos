{pkgs-old, ...}: {
  programs.gpg = {
    enable = true;
    settings.trust-model = "tofu+pgp";
    scdaemonSettings = {
      disable-ccid = true;
      pcsc-driver = "${pkgs-old.pcsclite.out}/lib/libpcsclite.so.1";
      card-timeout = "1";
      reader-port = "Yubico YubiKey";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;
    sshKeys = ["D2277B1C3C924964972148EF590B9F083697F9A8"];
    enableExtraSocket = true;
  };
}
