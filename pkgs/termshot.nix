{
  stdenv,
  termshot,
  buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.5";
  src = termshot;
  vendorHash = "sha256-hdez+FjYprXOsASjqerC1WR4+zPk+S61m2G5c55O8wU=";
}
