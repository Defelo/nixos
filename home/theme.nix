{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme.name = "Adapta-Nokto";
    theme.package = pkgs.adapta-gtk-theme;
    iconTheme.name = "breeze-dark";
    iconTheme.package = pkgs.breeze-icons;
    font.name = "Cantarell";
    font.size = 12;
    font.package = pkgs.cantarell-fonts;
  };

  home.pointerCursor = {
    package = pkgs.breeze-gtk;
    gtk.enable = true;
    name = "breeze_cursors";
    size = 16;
  };

  fonts.fontconfig.enable = true;
}
