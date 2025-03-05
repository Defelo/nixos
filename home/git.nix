{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Defelo";
    userEmail = "mail@defelo.de";
    difftastic.enable = true;
    signing = {
      key = "E7FE2087E4380E64";
      signByDefault = true;
    };
    aliases = {
      l = "log --graph";
      p = "pull --prune --rebase --autostash";
      ai = "add --intent-to-add";
    };
    ignores = [
      ".direnv"
      ".devenv"
      "result"
      "result-*"
      "repl-result-*"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      push.default = "upstream";
      rerere.enabled = true;
      merge.conflictStyle = "zdiff3";
      diff.algorithm = "histogram";
      diff.submodule = "log";
      diff.sopsdiffer.textconv =
        let
          conf = builtins.toFile "sops.yaml" (
            builtins.toJSON {
              creation_rules = [
                { key_groups = [ { pgp = [ "61303BBAD7D1BF74EFA44E3BE7FE2087E4380E64" ]; } ]; }
              ];
            }
          );
        in
        "${pkgs.sops}/bin/sops --config ${conf} -d";
      sendemail = {
        smtpserver = "mail.defelo.de";
        smtpuser = "mail@defelo.de";
        smtpencryption = "ssl";
        smtpserverport = 465;
        annotate = true;
      };
      credential."smtp://mail.defelo.de:465".helper =
        let
          helper = pkgs.writeShellScript "git-credential-helper" ''
            [[ "$1" = get ]] || exit 1
            pw=$(pass email/mail@defelo.de)
            echo "password=$pw"
          '';
        in
        ''!${helper} "$@"'';
    };
  };
}
