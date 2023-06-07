{
  pkgs,
  pkgs-stable,
  helix,
  ...
}: {
  programs.helix = {
    enable = true;
    package = helix.packages.${pkgs.system}.default;
    languages.language-server = {
      rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        config = {
          checkOnSave.command = "clippy";
          cargo.features = "all";
        };
      };
      pyright = {
        command = "${pkgs-stable.pyright}/bin/pyright-langserver";
        args = ["--stdio"];
        config = {};
      };
      nil.command = "${pkgs.nil}/bin/nil";
      bash-language-server = {
        command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
        args = ["start"];
      };
    };
    languages.language = [
      {
        name = "python";
        auto-format = true;
        language-servers = [{name = "pyright";}];
        formatter = {
          command = "/bin/sh";
          args = ["-c" "${pkgs.isort}/bin/isort - | ${pkgs.black}/bin/black -q -l 120 -C -"];
        };
      }
      {
        name = "nix";
        auto-format = true;
        language-servers = [{name = "nil";}];
        formatter.command = "${pkgs.alejandra}/bin/alejandra";
      }
      # {
      #   name = "latex";
      #   auto-format = true;
      #   language-server.command = "${pkgs.texlab}/bin/texlab";
      # }
      {
        name = "bash";
        auto-format = true;
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
