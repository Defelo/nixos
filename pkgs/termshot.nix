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
  vendorHash = "sha256-b076spsocuBIbKmEpDW7KUqFtxdfqtCg4jLjJjqdh8E=";
}
