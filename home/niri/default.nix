{
  config,
  lib,
  pkgs,
  ...
}:
let
  lock-command = map (x: ''"${x}"'') [
    (lib.getExe pkgs.swaylock-effects)
    "--screenshots"
    "--clock"
    "--submit-on-touch"
    "--show-failed-attempts"
    "--effect-pixelate=8"
    "--fade-in=0.5"
  ];

  rofipass-command =
    let
      runtimeDependencies = lib.attrValues {
        inherit (pkgs)
          pass
          wl-clipboard
          rofi-wayland
          dunst
          clipman
          ;
      };
    in
    pkgs.writeShellScript "rofipass-wrapped.sh" ''
      export PASSWORD_STORE_DIR=${lib.escapeShellArg config.programs.password-store.settings.PASSWORD_STORE_DIR}
      export PATH=${lib.makeBinPath runtimeDependencies}:$PATH
      exec -a rofipass.sh ${../scripts/rofipass.sh} "$@"
    '';
in
{
  home.file.".config/niri/config.kdl".source = pkgs.replaceVars ./config.kdl {
    inherit lock-command rofipass-command;
    DEFAULT_AUDIO_SINK = null;
    DEFAULT_AUDIO_SOURCE = null;
  };

  systemd.user.services.swaybg = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${../../wallpapers/nix-snowflake-dark.png}";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${lib.getExe pkgs.xwayland-satellite} :0";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  xdg.autostart.enable = false;
}
