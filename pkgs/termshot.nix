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
  vendorHash = "sha256-47AVgmGXENUzJP8ooosawCZFbizfggRM4juNiKIz9ws";
}
