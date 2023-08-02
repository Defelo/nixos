{sops-nix, ...}: {
  imports = [sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/persistent/root/.config/sops/age/keys.txt";
  };
}
