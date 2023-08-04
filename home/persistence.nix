{
  data = {
    directories = [
      ".config/dconf"
      ".config/fcitx5"
      ".config/gh"
      ".config/syncthing"
      ".gnupg"
      ".password-store"
      ".ssh"
      ".timetracker"

      "nixos"
      "Persistent"
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
      ".config/Signal Beta"
      ".config/Signal"
      ".config/Slack"
      ".config/discordcanary"
      ".config/obsidian"
      ".config/spotify"
      ".local/share/TelegramDesktop"
      ".local/share/direnv/allow"
      ".local/state/wireplumber"
      ".thunderbird"
      ".yubico"
    ];
    files = [];
  };
}
