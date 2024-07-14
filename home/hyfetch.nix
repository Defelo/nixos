{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "rainbow";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align.mode = "horizontal";
      backend = "fastfetch";
    };
  };

  programs.fastfetch.enable = true;
}
