{
  nixpkgs,
  home-manager,
  ...
} @ inputs:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ../common.nix
    ./hardware-configuration.nix

    ./boot.nix
    ./networking.nix
    ./users.nix
    ./services.nix
    ./x11.nix
    ./zram.nix

    home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = inputs;
      };
    }
  ];
}
