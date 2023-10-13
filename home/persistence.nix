{
  data = {
    directories = [
      ".config/dconf"
      ".config/fcitx5"
      ".config/gh"
      ".config/syncthing"
      ".gnupg"
      ".local/share/PrismLauncher/instances"
      ".password-store"
      ".ssh"
      ".timetracker"

      "nixos"
      "Persistent"
      "Downloads"
    ];
    files = [];
  };

  cache = {
    directories = [
      ".cache/nix"
      ".cache/spotify"
      ".cargo"
      ".config/BraveSoftware"
      ".config/Element"
      ".config/discordcanary"
      ".config/obsidian"
      ".config/spotify"
      ".local/share/PrismLauncher"
      ".local/share/Steam"
      ".local/share/containers"
      ".local/share/waydroid"
      ".local/state/wireplumber"
      ".thunderbird"
    ];
    files = [];
  };
}
