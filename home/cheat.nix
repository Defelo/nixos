{
  pkgs,
  cheatsheets,
  ...
}: {
  home.packages = [pkgs.cheat];
  home.file.cheat = {
    target = ".config/cheat/conf.yml";
    text = builtins.toJSON {
      editor = "hx";
      colorize = true;
      style = "monokai";
      formatter = "terminal256";
      pager = "less -FRX";
      cheatpaths = [
        {
          name = "community";
          path = cheatsheets;
          tags = ["community"];
          readonly = true;
        }
      ];
    };
  };
}
