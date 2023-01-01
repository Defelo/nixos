{
  nixpkgs,
  home-manager,
  ...
} @ inputs:
nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  pkgs = import ../unfree.nix {inherit nixpkgs system;};
  specialArgs = inputs;
  modules = [
    ../common.nix
    ./hardware-configuration.nix

    ./boot.nix
    ./networking.nix
    ./users.nix
    ./services.nix
    ./x11.nix
    ./xbanish.nix
    ./zram.nix
    ./backlight.nix
    ./audio.nix
    ./bluetooth.nix

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
