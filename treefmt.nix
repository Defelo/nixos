{
  settings.global.excludes = [
    # no formatter available
    ".gitattributes"
    "LICENSE"
    "*.kdl"
    "*.md"
    "*.rasi"

    # generated/managed by other programs
    "home/xournalpp/settings/*"
    "home/zsh/p10k.zsh"
    "hosts/*/hardware-configuration.nix"
    "secrets/*"
    "*/secrets/*"

    # not text
    "*.jpg"
    "*.png"
  ];

  programs.black.enable = true;

  programs.nixfmt.enable = true;
  programs.nixfmt.strict = true;

  programs.prettier.enable = true;

  programs.shfmt.enable = true;
}
