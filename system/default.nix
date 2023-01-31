{
  conf,
  nixpkgs,
  nixpkgs-small,
  nixpkgs-fork,
  home-manager,
  ...
} @ inputs: let
  inherit (conf) system;
  pkgs = import ./unfree.nix {inherit nixpkgs system;};
  pkgs-small = import ./unfree.nix {
    inherit system;
    nixpkgs = nixpkgs-small;
  };
  pkgs-fork = import ./unfree.nix {
    inherit system;
    nixpkgs = nixpkgs-fork;
  };
  specialArgs =
    inputs
    // {
      inherit pkgs-small pkgs-fork;
      _pkgs = import ../pkgs (inputs // {inherit pkgs pkgs-small pkgs-fork;});
    };
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
      ./steam.nix
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
