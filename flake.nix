{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs = {...} @ inputs: {
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
