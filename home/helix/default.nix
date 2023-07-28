{
  pkgs,
  helix,
  ...
}: {
  programs.helix = {
    enable = true;
    package = helix.packages.${pkgs.system}.default;
    settings = {
      theme = "dark_plus";
      editor = {
        line-number = "relative";
        mouse = false;
        cursorline = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker = {hidden = false;};
        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = [
            "version-control"
            "diagnostics"
            "selections"
            "position"
            "position-percentage"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "|";
        };
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        indent-guides = {render = true;};
        idle-timeout = 0;
        bufferline = "always";
        soft-wrap = {
          enable = true;
        };
      };
      keys = {
        normal = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
          "C-h" = "jump_view_left";
          "C-j" = "jump_view_down";
          "C-k" = "jump_view_up";
          "C-l" = "jump_view_right";
        };
        select = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
        };
        insert = {
          "C-space" = "completion";
        };
      };
    };
  };
}
