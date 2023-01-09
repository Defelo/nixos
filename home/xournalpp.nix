{pkgs, ...}: {
  home.packages = [pkgs.xournalpp];
  home.file.xournalpp = {
    source = ../xournalpp;
    target = ".config/xournalpp";
    recursive = true;
  };
}
