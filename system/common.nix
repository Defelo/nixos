{
  config,
  nixpkgs,
  pkgs,
  lib,
  ...
}: {
  boot.tmp.useTmpfs = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings.LC_TIME = "en_GB.UTF-8";
  console.keyMap = "de-latin1";

  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    attic-client
    age
    btdu
    comma
    # compsize
    dig
    duf
    eza
    file
    htop
    iw
    jq
    ncdu
    nix-tree
    nvd
    ranger
    renameutils
    ripgrep
    sd
    sops
    unp
    wget
    wireguard-tools
    wirelesstools
    xxd
    yq
    zip
  ];

  environment.pathsToLink = ["/share/zsh"];

  nix = {
    package = pkgs.nixVersions.latest;
    nixPath = ["nixpkgs=${nixpkgs}"];
    gc = {
      automatic = true;
      dates = "05:30";
      options = "--delete-older-than 3d";
    };
    settings = {
      keep-outputs = true;
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
      substituters = lib.mkAfter [
        "https://nix-community.cachix.org"
        "https://sandkasten.cachix.org"
        "https://attic.defelo.de/nixos"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "sandkasten.cachix.org-1:Pa7qfdlx7bZkko+ojaaEG9pyziZkaru9v4TfcioqNZw="
        "nixos:5Pnh7nNQP4a0E3R850micmqOUXhn6uvP+DsT2FU7vfI="
      ];
      netrc-file = config.sops.templates."nix-netrc".path;
    };
    registry = {
      nixpkgs = {
        from = {
          id = "nixpkgs";
          type = "indirect";
        };
        exact = true;
        flake = nixpkgs;
      };
    };
  };

  environment.sessionVariables.NIX_USER_CONF_FILES = config.sops.templates."nix".path;

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

  system.activationScripts.nvd-diff = ''
    if old_system=$(readlink /run/current-system); then
      ${pkgs.nvd}/bin/nvd --color=always --nix-bin-dir=/run/current-system/sw/bin/ diff $old_system $systemConfig
    fi
    if [[ -e /run/booted-system ]] && ! ${pkgs.diffutils}/bin/diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink $systemConfig/{initrd,kernel,kernel-modules}); then
      echo -e "\033[1m==> REBOOT REQUIRED! \033[0m"
    fi
  '';
  environment.shellAliases.needrestart = "sh -c 'diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /run/current-system/{initrd,kernel,kernel-modules})'";

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

  system.stateVersion = "23.11";

  sops = {
    secrets = {
      "nix/tokens/github".sopsFile = ../secrets/nix.yml;
      # atticd-atticadm make-token --sub nixos --validity 1y --pull nixos
      "nix/tokens/attic".sopsFile = ../secrets/nix.yml;
    };
    templates = {
      "nix" = {
        content = ''
          access-tokens = github.com=${config.sops.placeholder."nix/tokens/github"}
        '';
        mode = "444";
      };
      "nix-netrc" = {
        content = ''
          machine attic.defelo.de
          password ${config.sops.placeholder."nix/tokens/attic"}
        '';
        mode = "444";
      };
    };
  };
}
