{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cheatsheets = {
      url = "github:cheat/cheatsheets";
      flake = false;
    };
    helix.url = "github:pascalkuthe/helix/inline-diagnostics";
    cargo-clif-nix.url = "github:Defelo/cargo-clif-nix";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;

    defaultConfig = rec {
      uid = 1000;
      user = "felix";
      home = "/home/${user}";

      sway.output.scale = "1.0";

      borg.excludeSyncthing = false;

      tmpfsSize = "4G";

      extraConfig = {};
    };

    hosts = builtins.attrNames (builtins.readDir ./hosts);
    importHostConf = host:
      lib.recursiveUpdate defaultConfig (import ./hosts/${host} inputs
        // {
          hostname = host;
          hardware-configuration = ./hosts/${host}/hardware-configuration.nix;
        });
    mkNixOSConfig = host: import ./system (inputs // {conf = importHostConf host;});
  in {
    nixosConfigurations = builtins.listToAttrs (map (host: {
        name = host;
        value = mkNixOSConfig host;
      })
      hosts);
  };
}
