{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs-fork.url = "github:Defelo/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lunarvim = {
      url = "github:lunarvim/lunarvim/release-1.2/neovim-0.8";
      flake = false;
    };
    cheatsheets = {
      url = "github:cheat/cheatsheets";
      flake = false;
    };
    icat = {
      url = "github:atextor/icat";
      flake = false;
    };
    exa = {
      url = "github:ogham/exa";
      flake = false;
    };
    termshot = {
      url = "github:homeport/termshot";
      flake = false;
    };
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
