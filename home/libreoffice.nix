{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs) libreoffice hunspell;
    inherit (pkgs.hunspellDicts) en_US de_DE;
  };
}
