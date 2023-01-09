{pkgs, ...}: let
  calendars = map ({
      uri,
      username,
      name,
      ...
    } @ data: {
      id = builtins.hashString "sha256" "${uri}\n${username}\n${name}";
      inherit data;
    })
  (import ../secrets.nix).calendars;
in {
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings =
        builtins.foldl' (acc: x: acc // x) {
          "calendar.list.sortOrder" = builtins.concatStringsSep " " (map ({id, ...}: id) calendars);
          "calendar.timezone.local" = "Europe/Berlin";
          "calendar.view.visiblehours" = 16;
          "calendar.week.start" = 1;
        } (map ({
          id,
          data,
        }:
          pkgs.lib.attrsets.mapAttrs' (key: value: {
            name = "calendar.registry.${id}.${key}";
            inherit value;
          })
          data)
        calendars);
    };
  };
}
