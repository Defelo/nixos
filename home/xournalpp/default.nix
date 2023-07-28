{pkgs, ...}: {
  home.packages = [pkgs.xournalpp];
  home.file.xournalpp = {
    source = ./settings;
    target = ".config/xournalpp";
    recursive = true;
  };
}
