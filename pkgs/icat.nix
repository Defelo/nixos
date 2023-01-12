{
  stdenv,
  pkg-config,
  imlib2,
  xorg,
  ...
}:
stdenv.mkDerivation {
  pname = "icat";
  version = "0.5";
  src = builtins.fetchGit {
    url = "https://github.com/atextor/icat.git";
    rev = "9b5aa622fdfbfbd37a97c9b8d3258100e1d26cd6";
  };
  nativeBuildInputs = [pkg-config];
  buildInputs = [imlib2.dev xorg.libX11.dev];
  installPhase = "install -D icat $out/bin/icat";
}
