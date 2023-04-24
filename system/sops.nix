{sops-nix, ...}: {
  imports = [sops-nix.nixosModules.sops];
  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/root/.age.key";
    age.generateKey = true;
  };
}
