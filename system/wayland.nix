{
  conf,
  config,
  lib,
  pkgs,
  ...
}:
{
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];
  xdg.portal = {
    enable = true;
    config.common.default = "*";
  };

  hardware.graphics.enable = true;

  environment.systemPackages = [ pkgs.qt5.qtwayland ];

  programs.niri.enable = true;

  services.gnome.gnome-keyring.enable = false;

  xdg.autostart.enable = lib.mkForce false;
  services.xserver.desktopManager.runXdgAutostartIfNone = false;

  services.greetd = {
    enable = true;
    settings = {
      default_session.command =
        let
          shell = config.users.defaultUserShell;
        in
        "${pkgs.greetd.greetd}/bin/agreety --cmd ${shell}${shell.shellPath}";
      initial_session = {
        user = conf.user;
        command = "niri-session";
      };
    };
  };
}
