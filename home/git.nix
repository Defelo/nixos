{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Defelo";
    userEmail = "elodef42@gmail.com";
    difftastic.enable = true;
    signing = {
      key = "E7FE2087E4380E64";
      signByDefault = true;
    };
    aliases = {
      l = "log --graph";
      p = "pull --prune --rebase --autostash";
    };
    extraConfig = {
      diff.submodule = "log";
      diff.sopsdiffer.textconv = let
        conf = builtins.toFile "sops.yaml" (builtins.toJSON {
          creation_rules = [{key_groups = [{pgp = ["61303BBAD7D1BF74EFA44E3BE7FE2087E4380E64"];}];}];
        });
      in "${pkgs.sops}/bin/sops --config ${conf} -d";
    };
  };
}
