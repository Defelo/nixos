{
  nixpkgs,
  pkgs,
  ...
}: {
  boot.tmp.useTmpfs = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  environment.systemPackages = with pkgs; [
    age
    comma
    dig
    duf
    exa
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
    nixPath = ["nixpkgs=${nixpkgs}"];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://nix-community.cachix.org"
        "https://sandkasten.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "sandkasten.cachix.org-1:Pa7qfdlx7bZkko+ojaaEG9pyziZkaru9v4TfcioqNZw="
      ];
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

  system.activationScripts.nvd-diff = ''
    if old_system=$(readlink /run/current-system); then
      ${pkgs.nvd}/bin/nvd --color=always --nix-bin-dir=/run/current-system/sw/bin/ diff $old_system $systemConfig
    fi
    if [[ -e /run/booted-system ]] && ! ${pkgs.diffutils}/bin/diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink $systemConfig/{initrd,kernel,kernel-modules}); then
      echo -e "\033[1m==> REBOOT REQUIRED! \033[0m"
    fi
  '';
  environment.shellAliases.needrestart = "sh -c 'diff <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /run/current-system/{initrd,kernel,kernel-modules})'";

  system.stateVersion = "22.11";
}
