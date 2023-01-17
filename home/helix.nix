{pkgs, ...}: {
  programs.helix = {
    enable = true;
    languages = [
      {
        name = "python";
        auto-format = true;
        language-server = {
          command = "${pkgs.pyright}/bin/pyright-langserver";
          args = ["--stdio"];
        };
        config = {};
      }
      {
        name = "nix";
        auto-format = true;
        language-server.command = "${pkgs.nil}/bin/nil";
        formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
      }
      {
        name = "bash";
        auto-format = true;
        language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };
      }
    ];
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
        lsp = {display-messages = true;};
        indent-guides = {render = true;};
      };
      keys = {
        normal = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
        };
        select = {
          "0" = "goto_line_start";
          "$" = "goto_line_end";
          "G" = "goto_last_line";
        };
      };
    };
  };
}
