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
}
