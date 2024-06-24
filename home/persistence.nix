{
  data = {
    directories = [
      ".config/dconf"
      ".config/fcitx5"
      ".config/gh"
      ".config/syncthing"
      ".gnupg"
      ".local/share/Paradox Interactive"
      ".local/share/PrismLauncher/instances"
      ".local/share/zoxide"
      ".password-store"
      ".ssh"
      ".timetracker"
      ".zotero"

      "nixos"
      "Persistent"
      "Zotero"
    ];
    files = [];
  };

  cache = {
    directories = [
      ".cache/nix"
      ".cache/spotify"
      ".cache/zotero"
      ".cargo"
      ".config/BraveSoftware"
      ".config/Element"
      ".config/discordcanary"
      ".config/obsidian"
      ".config/spotify"
      ".local/share/PrismLauncher"
      ".local/share/Steam"
      ".local/share/containers"
      # ".local/share/waydroid"
      ".local/state/wireplumber"
      ".thunderbird"
      "Downloads"
    ];
    files = [];
  };
}
