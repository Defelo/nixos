{
  conf,
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  inherit (conf) system;
  pkgs = import ./unfree.nix {inherit nixpkgs system;};
  specialArgs = inputs // {_pkgs = import ../pkgs (inputs // {inherit pkgs;});};
in
  nixpkgs.lib.nixosSystem rec {
    inherit system pkgs specialArgs;
    modules = [
      ./common.nix
      conf.hardware-configuration

      ./audio.nix
      ./backlight.nix
      ./bluetooth.nix
      ./boot.nix
      ./fonts.nix
      ./networking.nix
      ./power.nix
      ./services.nix
      # ./steam.nix
      ./users.nix
      ./x11.nix
      ./xbanish.nix
      ./zram.nix

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
        };
      }
    ];
  }
