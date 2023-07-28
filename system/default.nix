{
  conf,
  nixpkgs,
  home-manager,
  ...
} @ inputs: let
  inherit (conf) system;

  importNixpkgs = src:
    import ./nixpkgs.nix {
      inherit system inputs;
      nixpkgs = src;
    };
  pkgs = importNixpkgs nixpkgs;
  extra-pkgs = with pkgs.lib;
    mapAttrs' (k: v: {
      name = removePrefix "nix" k;
      value = importNixpkgs v;
    }) (filterAttrs (k: _: hasPrefix "nixpkgs-" k) inputs);

  specialArgs = inputs // extra-pkgs;
in
  nixpkgs.lib.nixosSystem rec {
    inherit system pkgs specialArgs;
    modules = [
      ./common.nix
      conf.extraConfig
      conf.hardware-configuration

      ./audio.nix
      ./backlight.nix
      ./bluetooth.nix
      ./boot.nix
      ./borg.nix
      ./fonts.nix
      ./geoclue2.nix
      ./networking.nix
      ./power.nix
      ./services.nix
      ./sops.nix
      # ./steam.nix
      ./users.nix
      ./virt.nix
      ./wayland.nix

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
