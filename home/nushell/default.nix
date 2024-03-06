{pkgs, ...}: {
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    shellAliases = {
      l = "${pkgs.eza}/bin/eza -gal --git --group-directories-first";
      tre = "l -T";
      c = "clear";
      h = "cd; c";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };
}
