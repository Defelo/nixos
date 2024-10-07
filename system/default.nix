{
  config,
  home-manager,
  specialArgs,
  ...
}: {
  imports = [
    ./common.nix

    ./audio.nix
    ./backlight.nix
    ./backup.nix
    ./bluetooth.nix
    ./boot.nix
    ./btrbk.nix
    ./btrfs.nix
    ./emulation.nix
    ./env.nix
    ./fonts.nix
    ./geoclue2.nix
    ./kanata.nix
    ./networking.nix
    ./nix-ld.nix
    ./persistence.nix
    ./power.nix
    ./services.nix
    ./sops.nix
    ./ssh.nix
    ./steam.nix
    ./users.nix
    ./virt.nix
    ./wayland.nix

    home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = config._module.args // specialArgs // {system-config = config;};
  };
}
