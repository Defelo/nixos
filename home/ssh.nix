{...} @ inputs: {
  programs.ssh = {
    enable = true;
    serverAliveInterval = 20;
    extraConfig = ''
      TCPKeepAlive no
    '';
    matchBlocks = builtins.listToAttrs (map (host: {
        name = host.name;
        value = builtins.removeAttrs host ["name"];
      })
      ((import ../secrets.nix).ssh inputs));
  };
}
