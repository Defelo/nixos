{
  pkgs,
  inputs,
}:
builtins.listToAttrs (map (f: {
    name = pkgs.lib.removeSuffix ".nix" f;
    value = pkgs.lib.callPackageWith (pkgs // inputs) ./${f} {};
  })
  (builtins.filter (f: f != "default.nix") (builtins.attrNames (builtins.readDir ./.))))
