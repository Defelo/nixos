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
      linuxPackages_latest = prev.linuxPackages_latest.extend (lpfinal: lpprev: {
        rtl8821ce = lpprev.rtl8821ce.overrideAttrs ({src, ...}: {
          version = "${lpprev.kernel.version}-unstable-2024-01-20";
          src = final.fetchFromGitHub {
            inherit (src) owner repo;
            rev = "66983b69120a13699acf40a12979317f29012111";
            hash = "sha256-Zxb9cOgP67QdCeTNEme0tAsBqd9j/2k+gcE1QKkUQU4=";
          };
        });
      });

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
