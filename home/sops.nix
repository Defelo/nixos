{
  conf,
  sops-nix,
  ...
}: {
  imports = [sops-nix.homeManagerModules.sops];
  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "${conf.home}/.config/sops/age/keys.txt";
  };
}
