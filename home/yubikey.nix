{
  pkgs,
  pkgs-old,
  ...
}: {
  home.packages = with pkgs-old; [
    yubikey-manager
    yubikey-manager-qt
    yubioath-flutter
  ];

  systemd.user = let
    yktd = pkgs.yubikey-touch-detector;
  in {
    services = {
      yubikey-touch-detector = {
        Unit = {
          Description = "Detects when your YubiKey is waiting for a touch";
          Requires = "yubikey-touch-detector.socket";
        };
        Service = {
          ExecStart = "${yktd}/bin/yubikey-touch-detector --libnotify";
          Environment = "PATH=${pkgs.lib.makeBinPath (with pkgs; [gnupg])}";
          EnvironmentFile = "-%E/yubikey-touch-detector/service.conf";
        };
        Install = {
          Also = "yubikey-touch-detector.socket";
          WantedBy = ["default.target"];
        };
      };
    };
    sockets = {
      yubikey-touch-detector = {
        Unit = {
          Description = "Unix socket activation for YubiKey touch detector service";
        };
        Socket = {
          ListenStream = "%t/yubikey-touch-detector.socket";
          RemoveOnStop = "yes";
        };
        Install = {
          WantedBy = ["sockets.target"];
        };
      };
    };
  };
}
