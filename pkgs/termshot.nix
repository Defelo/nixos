{
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "termshot";
  version = "0.2.7";
  src = fetchFromGitHub {
    owner = "homeport";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sxp6abYq0MrqtqDdpffSBdZB3/EyIMF9Ixsc7IgW5hI=";
  };
  vendorHash = "sha256-jzDbA1iN+1dbTVgKw228TuCV3eeAVmHFDiHd2qF/80E=";
}
