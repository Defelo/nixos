{sops-nix, ...}: {
  imports = [sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/root/.config/sops/age/keys.txt";
  };
}
