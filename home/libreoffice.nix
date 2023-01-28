{
  pkgs,
  pkgs-small,
  ...
}: {
  home.packages = with pkgs;
    [
      pkgs-small.libreoffice
      hunspell
    ]
    ++ (with pkgs.hunspellDicts; [
      en_US
      de_DE
    ]);
}
