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
  vendorHash = "sha256-pzzeFpdHFXOwqthJOjab4C17QopO7s4CKyT10hAoouc=";
}
