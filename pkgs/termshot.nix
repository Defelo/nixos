{
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.5";
  src = fetchFromGitHub {
    owner = "homeport";
    repo = pname;
    rev = "v0.2.5";
    sha256 = "sha256-fAWxdXSuQQz04ZmU6S9WWrGYDx0/u20C1rDljY85Xfc=";
  };
  vendorHash = "sha256-NIJ6LkbHpHtcANj+hRuUA/Da6mkIrc3O0+fyuIJ67ZU=";
}
