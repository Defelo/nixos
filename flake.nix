{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    # nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cheatsheets = {
      url = "github:cheat/cheatsheets";
      flake = false;
    };
    helix.url = "github:helix-editor/helix";
    fenix.url = "github:nix-community/fenix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (nixpkgs) lib;

    eachDefaultSystem = lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];

    importNixpkgs = system: nixpkgs: let
      config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "obsidian"
          "steam"
          "steam-unwrapped"
          "steam-original"
          "steam-run"
          "spotify"
        ];
    in
      import nixpkgs {
        inherit system config;
        overlays = [
          (final: prev: {
            linuxPackages_latest = prev.linuxPackages_latest.extend (lpfinal: lpprev: {
              rtl8821ce = lpprev.rtl8821ce.overrideAttrs (
                {patches ? [], ...}: {
                  patches =
                    [
                      (final.fetchpatch {
                        name = "rtl8821ce-linux613";
                        url = "https://github.com/tomaspinho/rtl8821ce/commit/4c0f3cf7aec51c8d842f8df130227a69dbfb74a0.patch";
                        hash = "sha256-ms5S9KkulCAmWNl2SSyQs18QxIWFh8iwcaxwI74X2Uk=";
                      })
                    ]
                    ++ patches;
                }
              );
            });
          })
        ];
      };

    extra-pkgs = system:
      lib.pipe inputs [
        (lib.filterAttrs (k: _: lib.hasPrefix "nixpkgs-" k))
        (lib.mapAttrs' (k: v: {
          name = lib.removePrefix "nix" k;
          value = importNixpkgs system v;
        }))
      ];

    getSystemFromHardwareConfiguration = hostName: let
      f = import ./hosts/${hostName}/hardware-configuration.nix;
      args = builtins.functionArgs f // {lib.mkDefault = lib.id;};
    in
      (f args).nixpkgs.hostPlatform;

    mkHost = name: system:
      lib.nixosSystem {
        inherit system;
        pkgs = importNixpkgs system nixpkgs;
        specialArgs = inputs // (extra-pkgs system);
        modules = [
          ./hosts/${name}
          ./hosts/${name}/hardware-configuration.nix
          ./system
          {networking.hostName = name;}
        ];
      };
  in {
    nixosConfigurations = lib.pipe ./hosts [
      builtins.readDir
      (lib.filterAttrs (_: type: type == "directory"))
      (builtins.mapAttrs (name: _: mkHost name (getSystemFromHardwareConfiguration name)))
    ];

    packages = eachDefaultSystem (
      system: let
        pkgs = importNixpkgs system nixpkgs;
      in
        import ./scripts pkgs
        // {
          checks = let
            packages = pkgs.linkFarm "nixos-checks-packages" (lib.removeAttrs self.packages.${system} ["checks"]);
            hosts = pkgs.linkFarm "nixos-checks-hosts" (lib.mapAttrs (_: v: v.config.system.build.toplevel) self.nixosConfigurations);
          in
            pkgs.linkFarmFromDrvs "nixos-checks" [packages hosts];
        }
    );

    checks = let
      packages = lib.mapAttrs (_: v: lib.removeAttrs v ["ci" "checks"]) self.packages;
      nixosConfigurations =
        lib.mapAttrsToList (name: config: {
          ${getSystemFromHardwareConfiguration name}.${name} = config.config.system.build.toplevel;
        })
        self.nixosConfigurations;
    in
      builtins.foldl' lib.recursiveUpdate {} ([packages] ++ nixosConfigurations);
  };
}
