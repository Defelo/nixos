{
  inputs,
  system,
  ...
}: let
  iamb = inputs.iamb.packages.${system}.default;
in {
  home.packages = [iamb];
}
