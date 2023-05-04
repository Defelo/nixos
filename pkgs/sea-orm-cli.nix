{
  rustPlatform,
  fetchCrate,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "sea-orm-cli";
  version = "0.11.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-VRSdPsjRubJOsjdAxdnFCM9VmAVwGkXDvpXT4GF2jxY=";
  };

  cargoSha256 = "sha256-4lPtj11Gc+0r2WQT8gx8eX+YK5L+HnUBR0w6pm3VlRQ=";

  buildNoDefaultFeatures = true;
  buildFeatures = ["codegen" "cli" "runtime-async-std-rustls" "async-std"];
}
