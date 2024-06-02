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
    ];
  overlays = [
    (final: prev:
      import ../pkgs {
        inherit inputs;
        pkgs = prev;
      })
    (final: prev: {
      linuxPackages_latest = prev.linuxPackages_latest.extend (lpfinal: lpprev: {
        rtl8821ce = lpprev.rtl8821ce.overrideAttrs ({src, ...}: {
          version = "${lpprev.kernel.version}-unstable-2024-03-26";
          src = final.fetchFromGitHub {
            inherit (src) owner repo;
            rev = "f119398d868b1a3395f40c1df2e08b57b2c882cd";
            hash = "sha256-EfpKa5ZRBVM5T8EVim3cVX1PP1UM9CyG6tN5Br8zYww=";
          };
        });
      });
    })
  ];
}
