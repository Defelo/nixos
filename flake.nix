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

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.nixos = import ./hosts/vm inputs;
    nixosConfigurations.nixos-stick = import ./hosts/stick inputs;
    nixosConfigurations.nitrogen = import ./hosts/nitrogen inputs;

    formatter."x86_64-linux" = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
