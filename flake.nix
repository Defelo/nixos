{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
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
    helix.url = "github:helix-editor/helix";
    fenix.url = "github:nix-community/fenix";
  };

  outputs = {nixpkgs, ...} @ inputs: let
    inherit (nixpkgs) lib;
    defaultSystems = [
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    eachDefaultSystem = f:
      builtins.listToAttrs (map (system: {
          name = system;
          value = f system;
        })
        defaultSystems);

    defaultConfig = rec {
      uid = 1000;
      user = "felix";
      home = "/home/${user}";

      sway.output.scale = "1.0";

      borg.excludeSyncthing = false;

      tmpfsSize = "4G";

      networking = {
        vpn.default = "72ab4eb3-3c9a-42c9-adeb-9f4730d540e6";
        vpn.full = "bb1d4d42-dedb-4598-8b81-d2147b3197ab";
        wifi.trusted = [
          "fad97450-a66a-44f9-894b-19d578ba6265"
          "9a3a989a-c30b-4b2c-be19-28094e503bf2"
        ];
      };

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
    packages = eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in
        import ./scripts pkgs
    );
  };
}
