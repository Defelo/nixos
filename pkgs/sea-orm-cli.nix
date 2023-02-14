{
  rustPlatform,
  fetchCrate,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "0.11.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-nFSouV23t0+CCvBXT/WhaTGoFtABnt9KjF9U0kb+zqI=";
  };

  cargoSha256 = "sha256-qJ+G5+KyoNsl3VKsHDdFD6l1MagqHd7N7TahK7B5ky8=";

  buildNoDefaultFeatures = true;
  buildFeatures = ["codegen" "cli" "runtime-async-std-rustls" "async-std"];
}
