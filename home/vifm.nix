{pkgs, ...}: {
  home.packages = with pkgs; [vifm];
  home.file.vifmrc = {
    source = ../vifmrc;
    target = ".config/vifm/vifmrc";
  };
}
