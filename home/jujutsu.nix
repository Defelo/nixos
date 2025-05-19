{ lib, pkgs, ... }:

{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Defelo";
        email = "mail@defelo.de";
      };
      signing = {
        behavior = "drop";
        backend = "gpg";
      };
      ui = {
        default-command = [ "log" ];
        show-cryptographic-signatures = true;
        diff.tool = [
          (lib.getExe pkgs.difftastic)
          "--color=always"
          "--background=light"
          "--display=side-by-side"
          "$left"
          "$right"
        ];
        diff-editor = ":builtin";
      };
      git = {
        sign-on-push = true;
      };
      templates = {
        log = "builtin_log_comfortable";
      };
    };
  };
}
