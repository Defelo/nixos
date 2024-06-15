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
in {
  base = nixpkgs.lib.nixosSystem {
    inherit system pkgs specialArgs;
    modules = [
      ./common.nix
      conf.extraConfig
      conf.hardware-configuration

      ./base.nix
      ./boot.nix
      ./filesystems.nix
    ];
  };

  full = nixpkgs.lib.nixosSystem {
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
      ./btrbk.nix
      ./btrfs.nix
      ./emulation.nix
      ./env.nix
      ./filesystems.nix
      ./fonts.nix
      ./geoclue2.nix
      ./networking.nix
      ./nix-ld.nix
      ./persistence.nix
      ./power.nix
      ./services.nix
      ./sops.nix
      ./steam.nix
      ./users.nix
      ./virt.nix
      ./wayland.nix

      home-manager.nixosModules.home-manager
      ({config, ...}: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs // {system-config = config;};
        };
      })
    ];
  };
}
