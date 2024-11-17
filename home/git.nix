{pkgs, ...}: {
  programs.git = {
    enable = true;
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
      diff.algorithm = "histogram";
      diff.submodule = "log";
      diff.sopsdiffer.textconv = let
        conf = builtins.toFile "sops.yaml" (builtins.toJSON {
          creation_rules = [{key_groups = [{pgp = ["61303BBAD7D1BF74EFA44E3BE7FE2087E4380E64"];}];}];
        });
      in "${pkgs.sops}/bin/sops --config ${conf} -d";
    };
  };
}
