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
    flake-utils.url = "github:numtide/flake-utils";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # lunarvim = {
    #   url = "github:lunarvim/lunarvim/release-1.2/neovim-0.8";
    #   flake = false;
    # };
    cheatsheets = {
      url = "github:cheat/cheatsheets";
      flake = false;
    };
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    helix.url = "github:pascalkuthe/helix/inline-diagnostics";
    cargo-clif-nix.url = "github:Defelo/cargo-clif-nix";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.pkgs = import ./pkgs (inputs // {inherit pkgs;});
    }))
    // {
      nixosConfigurations = let
        hosts = [./hosts/nitrogen.nix];
      in
        builtins.listToAttrs (map (host: let
            conf = import host inputs;
          in {
            name = conf.hostname;
            value = import ./system (inputs // {inherit conf;});
          })
          hosts);
    };
}
