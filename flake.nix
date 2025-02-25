{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-element.url = "github:NixOS/nixpkgs/56b616f7b84ddf156bb42ed2d6dc7c5da174fa07";
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
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      eachDefaultSystem = lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];

      importNixpkgs =
        system: nixpkgs:
        let
          config.allowUnfreePredicate =
            pkg:
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
        import nixpkgs { inherit system config; };

      extra-pkgs =
        system:
        lib.pipe inputs [
          (lib.filterAttrs (k: _: lib.hasPrefix "nixpkgs-" k))
          (lib.mapAttrs' (
            k: v: {
              name = lib.removePrefix "nix" k;
              value = importNixpkgs system v;
            }
          ))
        ];

      getSystemFromHardwareConfiguration =
        hostName:
        let
          f = import ./hosts/${hostName}/hardware-configuration.nix;
          args = builtins.functionArgs f // {
            lib.mkDefault = lib.id;
          };
        in
        (f args).nixpkgs.hostPlatform;

      mkHost =
        name: system:
        lib.nixosSystem {
          inherit system;
          pkgs = importNixpkgs system nixpkgs;
          specialArgs = inputs // (extra-pkgs system);
          modules = [
            ./hosts/${name}
            ./hosts/${name}/hardware-configuration.nix
            ./system
            { networking.hostName = name; }
          ];
        };
    in
    {
      nixosConfigurations = lib.pipe ./hosts [
        builtins.readDir
        (lib.filterAttrs (_: type: type == "directory"))
        (builtins.mapAttrs (name: _: mkHost name (getSystemFromHardwareConfiguration name)))
      ];

      packages = eachDefaultSystem (
        system:
        let
          pkgs = importNixpkgs system nixpkgs;
        in
        import ./scripts pkgs
        // {
          checks =
            let
              packages = pkgs.linkFarm "nixos-checks-packages" (
                lib.removeAttrs self.packages.${system} [ "checks" ]
              );
              hosts = pkgs.linkFarm "nixos-checks-hosts" (
                lib.mapAttrs (_: v: v.config.system.build.toplevel) self.nixosConfigurations
              );
            in
            pkgs.linkFarmFromDrvs "nixos-checks" [
              packages
              hosts
            ];
        }
      );

      checks =
        let
          packages = lib.mapAttrs (
            _: v:
            lib.removeAttrs v [
              "ci"
              "checks"
            ]
          ) self.packages;
          nixosConfigurations = lib.mapAttrsToList (name: config: {
            ${getSystemFromHardwareConfiguration name}.${name} = config.config.system.build.toplevel;
          }) self.nixosConfigurations;
        in
        builtins.foldl' lib.recursiveUpdate { } ([ packages ] ++ nixosConfigurations);

      formatter = eachDefaultSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
        in
        treefmtEval.config.build.wrapper
      );
    };
}
