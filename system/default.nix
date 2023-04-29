{
  conf,
  nixpkgs,
  nixpkgs-stable,
  # nixpkgs-small,
  # nixpkgs-fork,
  home-manager,
  ...
} @ inputs: let
  inherit (conf) system;
  pkgs = import ./unfree.nix {inherit nixpkgs system;};
  pkgs-stable = import ./unfree.nix {
    inherit system;
    nixpkgs = nixpkgs-stable;
  };
  # pkgs-small = import ./unfree.nix {
  #   inherit system;
  #   nixpkgs = nixpkgs-small;
  # };
  # pkgs-fork = import ./unfree.nix {
  #   inherit system;
  #   nixpkgs = nixpkgs-fork;
  # };
  specialArgs =
    inputs
    // {
      inherit pkgs-stable;
      # inherit pkgs-small pkgs-fork;
      _pkgs = import ../pkgs (inputs
        // {
          inherit pkgs pkgs-stable;
          # inherit pkgs-small;
          # inherit pkgs-fork;
        });
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
      ./geoclue2.nix
      ./networking.nix
      ./power.nix
      ./services.nix
      ./sops.nix
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
