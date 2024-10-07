{
  conf,
  sops-nix,
  system-config,
  ...
}: let
  inherit (system-config.users.users.${conf.user}) uid;
in {
  imports = [sops-nix.homeManagerModules.sops];
  sops = {
    age.keyFile = "/persistent/data/home/${conf.user}/.config/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/${toString uid}/secrets";
    defaultSecretsMountPoint = "/run/user/${toString uid}/secrets.d";
  };
}
