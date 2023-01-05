{
  conf,
  nixpkgs,
  home-manager,
  ...
} @ inputs:
nixpkgs.lib.nixosSystem rec {
  inherit (conf) system;
  pkgs = import ./unfree.nix {inherit nixpkgs system;};
  specialArgs = inputs;
  modules = [
    ./common.nix
    conf.hardware-configuration

    ./audio.nix
    ./backlight.nix
    ./bluetooth.nix
    ./boot.nix
    ./networking.nix
    ./power.nix
    ./services.nix
    ./users.nix
    ./x11.nix
    ./xbanish.nix
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
