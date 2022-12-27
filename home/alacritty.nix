{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      # env.TERM = "xterm-256color";
      window = {
        # opacity = 0.8;
        title = "Alacritty";
        dynamic_title = false;
      };
      font = {
        normal.family = "MesloLGS NF";
        bold.family = "MesloLGS NF";
        italic.family = "MesloLGS NF";
        bold_italic.family = "MesloLGS NF";
        size = 7;
      };
    };
  };
}
