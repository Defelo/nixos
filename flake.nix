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
  };

  outputs = inputs: {
    nixosConfigurations.nixos = import ./hosts/vm inputs;
  };
}
