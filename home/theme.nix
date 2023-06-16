{
  pkgs,
  conf,
  ...
}: {
  gtk = {
    enable = true;
    theme.name = "Adapta-Nokto";
    theme.package = pkgs.adapta-gtk-theme;
    iconTheme.name = "breeze-dark";
    iconTheme.package = pkgs.breeze-icons;
    font.name = "Cantarell";
    font.size = 12;
    font.package = pkgs.cantarell-fonts;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  sops.secrets."gtk/bookmarks" = {
    format = "binary";
    sopsFile = ../secrets/gtk/bookmarks;
    path = "${conf.home}/.config/gtk-3.0/bookmarks";
  };

  home.pointerCursor = {
    package = pkgs.breeze-gtk;
    gtk.enable = true;
    name = "breeze_cursors";
    size = 16;
  };

  fonts.fontconfig.enable = true;
}
