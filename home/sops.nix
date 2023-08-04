{
  conf,
  sops-nix,
  ...
}: {
  imports = [sops-nix.homeManagerModules.sops];
  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/persistent/data${conf.home}/.config/sops/age/keys.txt";
    defaultSymlinkPath = "/run/user/${toString conf.uid}/secrets";
    defaultSecretsMountPoint = "/run/user/${toString conf.uid}/secrets.d";
  };
}
