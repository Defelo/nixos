{
  nixpkgs,
  system,
}:
import nixpkgs {
  inherit system;
  config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "discord-canary"
      "obsidian"
      "slack"
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
    ];
  overlays = [
    (self: super: {
      signal-desktop = super.signal-desktop.overrideAttrs (old: {
        preFixup =
          old.preFixup
          + ''
            gappsWrapperArgs+=(
              --add-flags "--enable-features=UseOzonePlatform"
              --add-flags "--ozone-platform=wayland"
            )
          '';
      });
    })
  ];
}
