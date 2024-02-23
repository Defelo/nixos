{
  nixpkgs,
  system,
  inputs,
}:
import nixpkgs {
  inherit system;
  config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      "discord-canary"
      "obsidian"
      "steam"
      "steam-original"
      "steam-run"
      "spotify"
      "vmware-workstation"
    ];
  overlays = [
    (final: prev:
      import ../pkgs {
        inherit inputs;
        pkgs = prev;
      })
    (final: prev: {
      obsidian =
        (prev.obsidian.overrideAttrs ({src, ...}: rec {
          version = "1.5.8";
          src = prev.fetchurl {
            url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/obsidian-${version}.tar.gz";
            hash = "sha256-oc2iA2E3ac/uUNv6unzfac5meHqQzmzDVl/M9jNpS/M=";
          };
        }))
        .override {electron = prev.electron_28;};
    })
  ];
}
