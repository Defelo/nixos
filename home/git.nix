{...}: {
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
    };
  };
}
