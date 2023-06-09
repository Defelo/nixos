{
  fetchFromGitHub,
  stdenv,
  pkg-config,
  imlib2,
  xorg,
  ...
}:
stdenv.mkDerivation rec {
  pname = "icat";
  version = "0.5";
  src = fetchFromGitHub {
    owner = "atextor";
    repo = pname;
    rev = "v0.5";
    sha256 = "sha256-aiLPVdKSppT/PWPW0Ue475WG61pBLh8OtLuk2/UU3nM=";
  };
  nativeBuildInputs = [pkg-config];
  buildInputs = [imlib2.dev xorg.libX11.dev];
  installPhase = "install -D icat $out/bin/icat";
}
