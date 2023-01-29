{pkgs, ...}: {
  home.packages = with pkgs;
    [
      libreoffice
      hunspell
    ]
    ++ (with pkgs.hunspellDicts; [
      en_US
      de_DE
    ]);
}
