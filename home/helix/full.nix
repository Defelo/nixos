{pkgs, ...}: {
  imports = [./.];

  programs.helix.languages = {
    language-server = {
      rust-analyzer = {
        config = {
          checkOnSave.command = "clippy";
          cargo.features = "all";
        };
      };
      pyright = {
        command = "${pkgs.pyright}/bin/pyright-langserver";
        args = ["--stdio"];
        config = {};
      };
      nil.command = "${pkgs.nil}/bin/nil";
      bash-language-server = {
        command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
        args = ["start"];
      };
    };
    language = [
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
  };
}
