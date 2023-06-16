{
  conf,
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  inherit (conf) system;
  pkgs = import ./unfree.nix {inherit nixpkgs system;};
  extra-pkgs = pkgs.lib.mapAttrs' (k: v: {
    name = pkgs.lib.removePrefix "nix" k;
    value = import ./unfree.nix {
      inherit system;
      nixpkgs = v;
    };
  }) (pkgs.lib.filterAttrs (k: _: pkgs.lib.hasPrefix "nixpkgs-" k) inputs);
  specialArgs =
    inputs
    // extra-pkgs
    // {
      _pkgs = import ../pkgs (inputs
        // extra-pkgs
        // {inherit pkgs;});
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
      ./wayland.nix
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
