{ sops-nix, ... }:
{
  imports = [ sops-nix.nixosModules.sops ];
  sops = {
    age.keyFile = "/persistent/data/root/.config/sops/age/keys.txt";
  };
}
