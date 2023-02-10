{
  stdenv,
  termshot,
  buildGoModule,
  ...
}:
buildGoModule {
  pname = "termshot";
  version = "0.2.5";
  src = termshot;
  vendorHash = "sha256-STGDC26A8ui6kiIxYeLFmMYG+KninySXZK1F0zKf+5U=";
}
