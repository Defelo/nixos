{
  conf,
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  services.dbus.enable = true;
  services.dbus.packages = [pkgs.gcr];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
  };

  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    qt5.qtwayland
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session.command = let
        shell = config.users.defaultUserShell;
      in "${pkgs.greetd.greetd}/bin/agreety --cmd ${shell}${shell.shellPath}";
      initial_session = {
        user = conf.user;
        command = "sway";
      };
    };
  };
}
