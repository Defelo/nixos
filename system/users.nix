{ conf, config, ... }:

{
  users.mutableUsers = false;
  users.users.${conf.user} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "libvirtd"
      "restic"
    ];
    hashedPasswordFile = config.sops.secrets."user/hashedPassword".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0+Dd5FL6zKIxkjJaOb+/7fp5YtePkDdGasYESAl0br"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCqDljgWk+qK1pHdTZdgFgXcMdizAz7OmGR9fx0yROQ6+Ja7zUxnAxOi0ijOk8HLWrZ9xu/TqKPvF29hndCEJtg="
    ];
  };

  home-manager.users =
    let
      hm = import ../home;
    in
    {
      ${conf.user} = {
        imports = hm.user;
        home.username = conf.user;
        home.homeDirectory = "/home/${conf.user}";
      };
      root = {
        imports = hm.root;
        home.username = "root";
        home.homeDirectory = "/root";
      };
    };

  # security.sudo.wheelNeedsPassword = false;
  security.pam.u2f = {
    enable = true;

    # $ nix shell nixpkgs#pam_u2f --command pamu2fcfg
    # user=root, group=users, mode=640
    settings.authfile = "/persistent/cache/u2f_keys";
  };

  sops.secrets."user/hashedPassword" = {
    sopsFile = ../hosts/${config.networking.hostName}/secrets/default.yml;
    neededForUsers = true;
  };
}
