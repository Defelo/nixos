{
  icat,
  stdenv,
  pkg-config,
  imlib2,
  xorg,
  ...
}:
stdenv.mkDerivation {
  pname = "icat";
  version = "0.5";
  src = icat;
  nativeBuildInputs = [pkg-config];
  buildInputs = [imlib2.dev xorg.libX11.dev];
  installPhase = "install -D icat $out/bin/icat";
}
